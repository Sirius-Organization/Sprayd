//
//  FeaturedView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI
import SwiftData

struct FeaturedView: View {
    struct CityPreview: Identifiable {
        let title: String
        let imageURL: URL?

        var id: String { title }
    }

    enum Layout {
        static let referenceFeedWidth: CGFloat = 345
        static let featuredImageHeight: CGFloat = 122
        static let discoverHeroImageHeight: CGFloat = 192
        static let discoverGridImageHeight: CGFloat = 122
        static let artworkCornerRadius: CGFloat = 18
        static let discoverGridColumnWidth: CGFloat = (referenceFeedWidth - Metrics.oneAndHalfModule) / 2

        // Keep the current visual proportions on the reference layout while scaling with real card width.
        static let discoverHeroImageAspectRatio: CGFloat = referenceFeedWidth / discoverHeroImageHeight
        static let discoverGridImageAspectRatio: CGFloat = discoverGridColumnWidth / discoverGridImageHeight
    }

    let onSelectItem: (ArtItem) -> Void

    init(onSelectItem: @escaping (ArtItem) -> Void = { _ in }) {
        self.onSelectItem = onSelectItem
    }

    @Environment(\.modelContext) var modelContext
    @State var searchText = ""
    @State var searchResults: [ArtItem] = []
    @State var isSearching = false
    @State var isSearchFocused = false
    @State var searchErrorMessage: String?
    @Query(
        sort: [
            SortDescriptor(\ArtItem.createdAt, order: .reverse),
            SortDescriptor(\ArtItem.name)
        ]
    )
    var items: [ArtItem]

    let gridColumns = [
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule),
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule)
    ]

    var featuredItem: ArtItem? {
        items.first
    }

    var discoverItems: [ArtItem] {
        Array(items.dropFirst())
    }

    var cities: [CityPreview] {
        var orderedKeys: [String] = []
        var previewsByKey: [String: CityPreview] = [:]

        for item in items {
            guard let city = item.cityName else { continue }
            let key = normalizedCityKey(city)

            if let existingPreview = previewsByKey[key] {
                guard existingPreview.imageURL == nil, let imageURL = item.primaryImageURL else { continue }

                previewsByKey[key] = CityPreview(
                    title: existingPreview.title,
                    imageURL: imageURL
                )
            } else {
                previewsByKey[key] = CityPreview(
                    title: city,
                    imageURL: item.primaryImageURL
                )
                orderedKeys.append(key)
            }
        }

        return orderedKeys.compactMap { previewsByKey[$0] }
    }

    var trimmedSearchQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isShowingSearchResults: Bool {
        !trimmedSearchQuery.isEmpty
    }

    var isSearchModeActive: Bool {
        isSearchFocused || isShowingSearchResults
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            if isSearchModeActive {
                Color.black.opacity(0.18)
                    .ignoresSafeArea()
            }

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.tripleModule) {
                    searchBar

                    if isSearchModeActive {
                        searchResultsSection
                    } else {
                        feedSections
                    }

                    Color.clear
                        .frame(height: Metrics.doubleModule)
                }
            }
            .safeAreaPadding(.horizontal, Metrics.tripleModule)
            .safeAreaPadding(.top, Metrics.oneAndHalfModule)
            .safeAreaPadding(.bottom, Metrics.oneAndHalfModule)
            .refreshable {
                await refresh()
            }
            .task(id: trimmedSearchQuery) {
                await performSearch(for: trimmedSearchQuery)
            }
        }
    }

    @MainActor
    private func refresh() async {
        do {
            let service = ArtSyncService(modelContext: modelContext)
            try await service.syncArtItems()

            if isShowingSearchResults {
                searchResults = try await service.searchArtItems(matching: trimmedSearchQuery)
                searchErrorMessage = nil
            }
        } catch {
            if isShowingSearchResults {
                searchResults = []
                searchErrorMessage = message(for: error)
            }
            print("Refresh sync error:", error)
        }
    }

    func discoverLargeCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, aspectRatio: Layout.discoverHeroImageAspectRatio)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(Font.InstrumentBold20)
                        .foregroundStyle(Color.appPrimaryText)

                    metadataLine(text: displayLocation(for: item), icon: Icons.location, font: .InstrumentMedium13)
                    dateLine(createdAt: item.createdAt, font: .InstrumentMedium13)
                    personText(label: "Creator", value: item.author, font: .InstrumentMedium13)

                    if let uploadedBy = uploadedByText(for: item) {
                        personText(label: "Uploaded by", value: uploadedBy, font: .InstrumentMedium13)
                    }
                }

                Spacer()

                favoriteButton(for: item)
                    .padding(.top, Metrics.module)
            }
        }
        .padding(Metrics.oneAndHalfModule)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.appPrimaryText.opacity(0.22), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func discoverSmallCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, aspectRatio: Layout.discoverGridImageAspectRatio)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold17)
                        .foregroundStyle(Color.appPrimaryText)
                        .lineLimit(1)

                    personLine(label: "Creator", value: item.author, size: 16, font: .InstrumentMedium10)

                    if let uploadedBy = uploadedByText(for: item) {
                        Text("Uploaded by: \(uploadedBy)")
                            .font(.InstrumentMedium10)
                            .foregroundStyle(Color.secondaryColor)
                            .lineLimit(1)
                    }

                    Text(uploadDateText(for: item.createdAt))
                        .font(.InstrumentMedium10)
                        .foregroundStyle(Color.secondaryColor)
                        .lineLimit(1)
                }

                Spacer(minLength: Metrics.module)

                favoriteButton(for: item)
                    .scaleEffect(0.9, anchor: .topTrailing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func artworkImage(for item: ArtItem, height: CGFloat) -> some View {
        artworkImageContent(for: item)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.artworkCornerRadius, style: .continuous)
            )
    }

    func artworkImage(for item: ArtItem, aspectRatio: CGFloat) -> some View {
        Color.clear
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay {
                artworkImageContent(for: item)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: Layout.artworkCornerRadius, style: .continuous)
            )
    }

    private func artworkImageContent(for item: ArtItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.artworkCornerRadius, style: .continuous)
                .fill(Color.appMutedFill)

            if let imageURL = item.primaryImageURL {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        placeholderArtworkImage
                    }
                }
            } else {
                placeholderArtworkImage
            }
        }
    }

    private var placeholderArtworkImage: some View {
        Icons.photo
            .foregroundStyle(Color.secondaryColor.opacity(0.8))
            .font(.system(size: 34, weight: .medium))
    }

    private func displayLocation(for item: ArtItem) -> String {
        cleanedText(item.location) ?? "Location pending"
    }

    func uploadedByText(for item: ArtItem) -> String? {
        guard let uploadedBy = item.uploadedBy else {
            return nil
        }

        return cleanedText(uploadedBy)
    }

    private func cleanedText(_ value: String) -> String? {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? nil : trimmedValue
    }

    private func normalizedCityKey(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }
}

#Preview {
    FeaturedView()
        .modelContainer(sharedModelContainer)
}
