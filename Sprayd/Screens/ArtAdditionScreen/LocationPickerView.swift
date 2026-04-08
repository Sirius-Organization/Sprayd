//
//  LocationPickerView.swift
//  Sprayd
//

internal import Combine
import SwiftUI
import MapKit
import CoreLocation

// MARK: - Model

struct PickedLocation {
    let coordinate: CLLocationCoordinate2D
    let displayName: String
}

// MARK: - View

struct LocationPickerView: View {
    // MARK: - Constants

    private enum Const {
        static let detailSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        static let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        static let flyDuration: TimeInterval = 0.35
        static let pinDuration: TimeInterval = 0.2

        static let autocompleteDebounceNanoseconds: UInt64 = 350_000_000
        static let suggestionsMaxHeight: CGFloat = 220
    }

    // MARK: - State

    @Environment(\.dismiss) private var dismiss

    @StateObject private var addressCompleter = AddressSearchCompleter()

    @State private var position: MapCameraPosition = .region(Const.defaultRegion)
    @State private var currentMapRegion = Const.defaultRegion
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var searchQuery = ""
    @State private var searchError: String?
    @State private var searchTask: Task<Void, Never>?
    @State private var autocompleteDebounceTask: Task<Void, Never>?
    @State private var searchResults: [MKMapItem] = []
    @State private var showResults = false

    @State private var isGeocoding = false
    @FocusState private var isSearchFieldFocused: Bool

    var onConfirm: (PickedLocation) -> Void

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                mapLayer
            }
            .navigationTitle("Pick location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .sheet(isPresented: $showResults) { resultsSheet }
        }
        .onDisappear {
            autocompleteDebounceTask?.cancel()
            addressCompleter.cancel()
        }
    }
}

// MARK: - LocationPickerView + Subviews & Actions

private extension LocationPickerView {
    var searchBar: some View {
        VStack(alignment: .leading, spacing: Metrics.halfModule) {
            HStack(spacing: Metrics.module) {
                TextField("Search address", text: $searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(16)
                    .textInputAutocapitalization(.words)
                    .focused($isSearchFieldFocused)
                    .onSubmit {
                        hideSuggestions()
                        search()
                    }
                    .onChange(of: searchQuery) { _, newValue in
                        scheduleAutocomplete(for: newValue)
                    }

                Button("Search") {
                    hideSuggestions()
                    search()
                }
                .disabled(searchQuery.trimmingCharacters(in: .whitespaces).isEmpty || searchTask != nil)
            }

            if isSearchFieldFocused, !addressCompleter.completions.isEmpty {
                autocompleteSuggestions
            }

            if searchTask != nil {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }

            if let searchError {
                Text(searchError)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.accentRed)
            }
        }
        .padding(.horizontal, Metrics.doubleModule)
        .padding(.vertical, Metrics.module)
        .background(Color.appBackground)
    }

    var autocompleteSuggestions: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(addressCompleter.completions.enumerated()), id: \.offset) { index, completion in
                    Button {
                        selectAutocompleteCompletion(completion)
                    } label: {
                        VStack(alignment: .leading, spacing: Metrics.halfModule) {
                            Text(completion.title)
                                .font(.InstrumentMedium16)
                                .foregroundStyle(Color.primary)
                                .multilineTextAlignment(.leading)
                            if !completion.subtitle.isEmpty {
                                Text(completion.subtitle)
                                    .font(.InstrumentRegular13)
                                    .foregroundStyle(Color.secondaryColor)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, Metrics.module)
                        .padding(.horizontal, Metrics.halfModule)
                    }
                    .buttonStyle(.plain)

                    if index < addressCompleter.completions.count - 1 {
                        Divider()
                            .padding(.leading, Metrics.halfModule)
                    }
                }
            }
        }
        .frame(maxHeight: Const.suggestionsMaxHeight)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.module))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.module)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }

    var mapLayer: some View {
        MapReader { proxy in
            Map(position: $position) {
                if let selectedCoordinate {
                    Marker("Selected", coordinate: selectedCoordinate)
                        .tint(Color.accentRed)
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                currentMapRegion = context.region
                addressCompleter.updateRegion(context.region)
            }
            .onTapGesture { point in
                hideSuggestions()
                isSearchFieldFocused = false
                guard let coordinate = proxy.convert(point, from: .local) else { return }
                withAnimation(.easeInOut(duration: Const.pinDuration)) {
                    selectedCoordinate = coordinate
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                autocompleteDebounceTask?.cancel()
                searchTask?.cancel()
                addressCompleter.cancel()
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            if isGeocoding {
                ProgressView()
            } else {
                Button("Done") { confirmSelection() }
                    .disabled(selectedCoordinate == nil)
            }
        }
    }

    var resultsSheet: some View {
        NavigationStack {
            List(searchResults, id: \.self) { item in
                Button { selectResult(item) } label: {
                    resultRow(item)
                }
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { showResults = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    func resultRow(_ item: MKMapItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.halfModule) {
            Text(item.name ?? item.placemark.title ?? "Location")
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.primary)

            if let subtitle = [item.placemark.locality, item.placemark.country]
                .compactMap({ $0 })
                .joined(separator: ", ")
                .nilIfEmpty
            {
                Text(subtitle)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.secondaryColor)
            }
        }
    }

    func scheduleAutocomplete(for raw: String) {
        autocompleteDebounceTask?.cancel()
        let trimmed = raw.trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty {
            addressCompleter.cancel()
            return
        }

        autocompleteDebounceTask = Task {
            try? await Task.sleep(nanoseconds: Const.autocompleteDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                addressCompleter.updateRegion(currentMapRegion)
                addressCompleter.updateQueryFragment(trimmed)
            }
        }
    }

    func hideSuggestions() {
        addressCompleter.cancel()
    }

    func selectAutocompleteCompletion(_ completion: MKLocalSearchCompletion) {
        isSearchFieldFocused = false
        hideSuggestions()

        let display = [completion.title, completion.subtitle]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        searchQuery = display

        searchTask?.cancel()
        searchError = nil

        searchTask = Task { @MainActor in
            defer { searchTask = nil }

            let request = MKLocalSearch.Request(completion: completion)
            request.region = currentMapRegion

            do {
                let response = try await MKLocalSearch(request: request).start()
                guard !Task.isCancelled else { return }

                let items = response.mapItems
                if items.isEmpty {
                    searchError = "No results found"
                } else if items.count == 1 {
                    applyResult(items[0])
                } else {
                    searchResults = items
                    showResults = true
                }
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                searchError = message(for: error)
            }
        }
    }

    func search() {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return }

        searchTask?.cancel()
        searchError = nil

        searchTask = Task { @MainActor in
            defer { searchTask = nil }

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = currentMapRegion

            do {
                let response = try await MKLocalSearch(request: request).start()
                guard !Task.isCancelled else { return }

                let items = response.mapItems
                if items.isEmpty {
                    searchError = "No results found"
                } else if items.count == 1 {
                    applyResult(items[0])
                } else {
                    searchResults = items
                    showResults = true
                }
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                searchError = message(for: error)
            }
        }
    }

    func selectResult(_ item: MKMapItem) {
        applyResult(item)
        showResults = false
    }

    func applyResult(_ item: MKMapItem) {
        let coordinate = item.placemark.coordinate
        guard CLLocationCoordinate2DIsValid(coordinate) else { return }

        let region = MKCoordinateRegion(center: coordinate, span: Const.detailSpan)
        withAnimation(.easeInOut(duration: Const.flyDuration)) {
            position = .region(region)
            currentMapRegion = region
            selectedCoordinate = coordinate
        }
        searchError = nil
    }

    func confirmSelection() {
        guard let coordinate = selectedCoordinate else { return }
        isGeocoding = true

        Task {
            let displayName = await reverseGeocode(coordinate)
            await MainActor.run {
                isGeocoding = false
                onConfirm(PickedLocation(coordinate: coordinate, displayName: displayName))
                dismiss()
            }
        }
    }

    func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                return Self.displayName(from: placemark, fallback: coordinate)
            }
        } catch {}

        return Self.formatCoordinate(coordinate)
    }

    static func displayName(
        from placemark: CLPlacemark,
        fallback coordinate: CLLocationCoordinate2D
    ) -> String {
        if let poi = placemark.areasOfInterest?.first, !poi.isEmpty { return poi }
        if let name = placemark.name, !name.isEmpty { return name }

        let address = [
            [placemark.subThoroughfare, placemark.thoroughfare]
                .compactMap { $0 }
                .joined(separator: " ")
                .nilIfEmpty,
            placemark.locality,
            placemark.administrativeArea,
            placemark.country
        ]
        .compactMap { $0 }
        .joined(separator: ", ")

        return address.isEmpty ? formatCoordinate(coordinate) : address
    }

    static func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }

    func message(for error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == MKError.errorDomain, nsError.code == MKError.placemarkNotFound.rawValue {
            return "No results found"
        }
        return error.localizedDescription
    }
}

// MARK: - AddressSearchCompleter

@MainActor
final class AddressSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published private(set) var completions: [MKLocalSearchCompletion] = []

    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }

    func updateRegion(_ region: MKCoordinateRegion) {
        completer.region = region
    }

    func updateQueryFragment(_ fragment: String) {
        completer.queryFragment = fragment
    }

    func cancel() {
        completer.cancel()
        completions = []
    }

    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        Task { @MainActor in
            self.completions = results
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError _: Error) {
        Task { @MainActor in
            self.completions = []
        }
    }
}

// MARK: - String+Helpers

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
