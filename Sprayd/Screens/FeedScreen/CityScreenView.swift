//
//  CityScreenView.swift
//  Sprayd
//
//  Created by User on 09.04.2026.
//

import SwiftUI
import SwiftData

struct CityScreenView: View {
    private enum Layout {
        static let cardCornerRadius: CGFloat = 24
        static let imageCornerRadius: CGFloat = 20
        static let imageHeight: CGFloat = 198
    }

    private let city: String

    @Query(
        sort: [
            SortDescriptor(\ArtItem.createdAt, order: .reverse),
            SortDescriptor(\ArtItem.name)
        ]
    )
    private var items: [ArtItem]

    init(city: String) {
        self.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var cityItems: [ArtItem] {
        items.filter(matchesSelectedCity)
    }

    private var objectsCountText: String {
        let count = cityItems.count
        let suffix = count == 1 ? "" : "s"
        return "\(count) object\(suffix) in this city"
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    headerCard

                    if cityItems.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: Metrics.doubleModule) {
                            ForEach(cityItems) { item in
                                NavigationLink {
                                    ArtObjectView(item: item)
                                } label: {
                                    cityItemCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .safeAreaPadding(.horizontal, Metrics.tripleModule)
            .safeAreaPadding(.top, Metrics.oneAndHalfModule)
            .safeAreaPadding(.bottom, Metrics.oneAndHalfModule)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            Text(city)
                .font(.ClimateCrisis22)
                .foregroundStyle(Color.appPrimaryText)

            Text(objectsCountText)
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
        .padding(Metrics.doubleModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.16), lineWidth: 1)
        )
    }

    private func cityItemCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item)

            HStack(alignment: .top, spacing: Metrics.module) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold20)
                        .foregroundStyle(Color.appPrimaryText)
                        .lineLimit(2)

                    locationLine(text: cleanedText(item.location) ?? city)
                    personLine(label: "Creator", value: item.author)

                    if let uploadedBy = uploadedByText(for: item) {
                        detailText("Uploaded by: \(uploadedBy)")
                    }

                    detailText("Uploaded: \(uploadDateText(for: item.createdAt))")
                }

                Spacer(minLength: Metrics.module)

                likesView(count: item.likesCount)
                    .padding(.top, Metrics.halfModule)
            }
        }
        .padding(Metrics.oneAndHalfModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.18), lineWidth: 1)
        )
    }

    private func artworkImage(for item: ArtItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous)
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
        .frame(maxWidth: .infinity)
        .frame(height: Layout.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous))
    }

    private func locationLine(text: String) -> some View {
        HStack(alignment: .center, spacing: Metrics.halfModule) {
            Icons.location

            Text(text)
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
                .lineLimit(2)
        }
    }

    private func personLine(label: String, value: String) -> some View {
        HStack(spacing: Metrics.module) {
            Circle()
                .fill(Color.appMutedFill)
                .frame(width: 22, height: 22)
                .overlay {
                    Icons.person
                        .font(.system(size: 8, weight: .medium))
                }

            detailText("\(label): \(value)")
        }
    }

    private func detailText(_ text: String) -> some View {
        Text(text)
            .font(.InstrumentRegular13)
            .foregroundStyle(Color.secondaryColor)
            .lineLimit(2)
    }

    private func likesView(count: Int) -> some View {
        HStack(spacing: Metrics.halfModule) {
            Text("\(count)")
                .font(.InstrumentMedium13)
                .foregroundStyle(Color.appPrimaryText)

            Icons.heart
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            Text("No objects yet")
                .font(.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)

            Text("Works from this city will appear here as soon as they are added to the feed.")
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Metrics.doubleModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.18), lineWidth: 1)
        )
    }

    private var placeholderArtworkImage: some View {
        Icons.photo
            .foregroundStyle(Color.secondaryColor.opacity(0.8))
            .font(.system(size: 34, weight: .medium))
    }

    private func matchesSelectedCity(_ item: ArtItem) -> Bool {
        guard let itemCity = item.cityName else {
            return false
        }

        return normalizedCityKey(itemCity) == normalizedCityKey(city)
    }

    private func normalizedCityKey(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }

    private func uploadedByText(for item: ArtItem) -> String? {
        cleanedText(item.uploadedBy)
    }

    private func cleanedText(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? nil : trimmedValue
    }

    private func uploadDateText(for date: Date) -> String {
        date.formatted(date: .numeric, time: .omitted)
    }
}

#Preview("City With Objects") {
    NavigationStack {
        CityScreenView(city: "Yekaterinburg")
    }
    .modelContainer(cityPreviewContainer)
}

#Preview("City Empty") {
    NavigationStack {
        CityScreenView(city: "Kazan")
    }
    .modelContainer(cityPreviewContainer)
}

@MainActor
private let cityPreviewContainer: ModelContainer = {
    let schema = Schema([
        Author.self,
        ArtItem.self,
        ArtImage.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        let container = try ModelContainer(for: schema, configurations: [configuration])

        let items = [
            ArtItem(
                name: "Wall Letters",
                itemDescription: "Large typographic mural on a warehouse facade.",
                images: [],
                location: "ул. Малышева, 21/4, Yekaterinburg",
                author: "Покрас Лампас",
                uploadedBy: "Team",
                createdAt: .now,
                state: .new,
                category: "Mural",
                likesCount: 18
            ),
            ArtItem(
                name: "Paper Gesture",
                itemDescription: "Monumental wall piece with a painted hand.",
                images: [],
                location: "Ленина 8, Yekaterinburg",
                author: "Case Maclaim",
                uploadedBy: "George",
                createdAt: .now.addingTimeInterval(-86_400),
                state: .new,
                category: "Mural",
                likesCount: 24
            ),
            ArtItem(
                name: "Signal Grid",
                itemDescription: "Abstract wall study in another city.",
                images: [],
                location: "Tverskaya 5, Moscow",
                author: "Local Artist",
                uploadedBy: "Alex",
                createdAt: .now.addingTimeInterval(-172_800),
                state: .new,
                category: "Street Art",
                likesCount: 7
            )
        ]

        for item in items {
            container.mainContext.insert(item)
        }

        try container.mainContext.save()
        return container
    } catch {
        fatalError("Failed to create city preview container: \(error)")
    }
}()
