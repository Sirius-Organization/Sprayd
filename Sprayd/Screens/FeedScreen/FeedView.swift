//
//  FeaturedView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI
import SwiftData

struct FeaturedView: View {
    @Query(
        sort: [
            SortDescriptor(\ArtItem.createdAt, order: .reverse),
            SortDescriptor(\ArtItem.name)
        ]
    )
    private var items: [ArtItem]

    private let gridColumns = [
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule),
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule)
    ]

    private var featuredItem: ArtItem? {
        items.first
    }

    private var discoverItems: [ArtItem] {
        Array(items.dropFirst())
    }

    private var cities: [String] {
        var seen = Set<String>()

        return items.compactMap { item in
            let city = item.location.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !city.isEmpty else { return nil }
            guard seen.insert(city).inserted else { return nil }
            return city
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.tripleModule) {
                    searchBar

                    if let featuredItem {
                        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                            sectionTitle("Featured")
                            featuredCard(item: featuredItem)
                        }
                    }

                    if !cities.isEmpty {
                        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                            sectionTitle("Cities")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Metrics.oneAndHalfModule) {
                                    ForEach(cities, id: \.self) { city in
                                        cityCard(title: city)
                                    }
                                }
                                .padding(.trailing, Metrics.module)
                            }
                        }
                    }

                    if !discoverItems.isEmpty {
                        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                            sectionTitle("Discover")

                            if let first = discoverItems.first {
                                discoverLargeCard(item: first)
                                    .padding(.bottom, Metrics.module)
                            }

                            LazyVGrid(columns: gridColumns, spacing: Metrics.doubleModule) {
                                ForEach(Array(discoverItems.dropFirst().enumerated()), id: \.offset) { _, item in
                                    discoverSmallCard(item: item)
                                }
                            }
                        }
                    }

                    if items.isEmpty {
                        emptyState
                    }

                    Color.clear
                        .frame(height: Metrics.doubleModule)
                }
            }
            .safeAreaPadding(.horizontal, Metrics.tripleModule)
            .safeAreaPadding(.top, Metrics.oneAndHalfModule)
            .safeAreaPadding(.bottom, Metrics.oneAndHalfModule)
            .refreshable {
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: Metrics.module) {
            Icons.magnifyingGlass
                .font(.system(size: 14, weight: .medium))

            Text("Search for an art object")
                .font(.InstrumentRegular13)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding(.horizontal, Metrics.oneAndHalfModule)
        .frame(height: 42)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.5))
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.ClimateCrisis22)
            .foregroundStyle(.black)
    }

    private func featuredCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold20)
                        .foregroundStyle(.black)

                    personLine(label: "Creator", value: item.author, size: 24, font: .InstrumentMedium13)

                    if let uploadedBy = uploadedByText(for: item) {
                        personLine(label: "Uploaded by", value: uploadedBy, size: 20, font: .InstrumentMedium13)
                    }

                    dateLine(createdAt: item.createdAt, font: .InstrumentMedium13)
                }

                Spacer()

                likesView(count: item.likesCount)
                    .padding(.top, Metrics.module)
            }
        }
    }

    private func cityCard(title: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))
                .frame(maxWidth: .infinity)
                .frame(height: 78)

            HStack(alignment: .top, spacing: Metrics.module) {
                Text(title)
                    .font(.InstrumentBold17)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: Metrics.halfModule)

                Icons.chevronRight
                    .font(.system(size: 11, weight: .semibold))
                    .padding(.top, 2)
                    .foregroundStyle(.black.opacity(0.75))
            }
            .frame(maxWidth: .infinity, minHeight: 42, alignment: .topLeading)
        }
        .frame(width: 116, alignment: .leading)
    }

    private func discoverLargeCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, height: 192)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(Font.InstrumentBold20)
                        .foregroundStyle(.black)

                    metadataLine(text: displayLocation(for: item), icon: Icons.location, font: .InstrumentMedium13)
                    dateLine(createdAt: item.createdAt, font: .InstrumentMedium13)
                    personText(label: "Creator", value: item.author, font: .InstrumentMedium13)

                    if let uploadedBy = uploadedByText(for: item) {
                        personText(label: "Uploaded by", value: uploadedBy, font: .InstrumentMedium13)
                    }
                }

                Spacer()

                likesView(count: item.likesCount)
                    .padding(.top, Metrics.module)
            }
        }
        .padding(Metrics.oneAndHalfModule)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.35), lineWidth: 1)
        )
    }

    private func discoverSmallCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold17)
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    personLine(label: "Creator", value: item.author, size: 16, font: .InstrumentMedium10)

                    if let uploadedBy = uploadedByText(for: item) {
                        Text("Uploaded by: \(uploadedBy)")
                            .font(.InstrumentMedium10)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }

                    Text(uploadDateText(for: item.createdAt))
                        .font(.InstrumentMedium10)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }

                Spacer(minLength: Metrics.module)

                likesView(count: item.likesCount)
                    .scaleEffect(0.9, anchor: .topTrailing)
            }
        }
    }

    private func likesView(count: Int) -> some View {
        HStack(spacing: Metrics.halfModule) {
            Text("\(count)")
                .font(.InstrumentMedium13)
                .foregroundStyle(.black)

            Icons.heart
        }
    }

    private var emptyState: some View {
        stateCard(
            title: "Nothing here yet",
            message: "Featured objects will appear here as soon as new works are added."
        )
    }

    private func stateCard(title: String, message: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            Text(title)
                .font(.InstrumentBold20)
                .foregroundStyle(.black)

            Text(message)
                .font(.InstrumentRegular13)
                .foregroundStyle(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Metrics.doubleModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.5))
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }

    private func personLine(label: String, value: String, size: CGFloat, font: Font) -> some View {
        HStack(spacing: Metrics.module) {
            Circle()
                .fill(Color.gray.opacity(0.45))
                .frame(width: size, height: size)
                .overlay {
                    Icons.person
                        .font(.system(size: max(7, size / 3)))
                }

            personText(label: label, value: value, font: font)
        }
    }

    private func personText(label: String, value: String, font: Font) -> some View {
        Text("\(label): \(value)")
            .font(font)
            .foregroundStyle(.black.opacity(0.8))
            .lineLimit(1)
    }

    private func metadataLine<Icon: View>(text: String, icon: Icon, font: Font) -> some View {
        HStack(spacing: Metrics.halfModule) {
            icon
                .frame(width: Metrics.oneAndHalfModule, height: Metrics.oneAndHalfModule)

            Text(text)
                .font(font)
                .foregroundStyle(.gray)
        }
    }

    private func dateLine(createdAt: Date, font: Font) -> some View {
        Text("Uploaded: \(uploadDateText(for: createdAt))")
            .font(font)
            .foregroundStyle(.gray)
            .lineLimit(1)
    }

    private func artworkImage(for item: ArtItem, height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))

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
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var placeholderArtworkImage: some View {
        Icons.photo
            .foregroundStyle(.gray.opacity(0.7))
            .font(.system(size: 34, weight: .medium))
    }

    private func displayLocation(for item: ArtItem) -> String {
        cleanedText(item.location) ?? "Location pending"
    }

    private func uploadedByText(for item: ArtItem) -> String? {
        guard let uploadedBy = item.uploadedBy else {
            return nil
        }

        return cleanedText(uploadedBy)
    }

    private func cleanedText(_ value: String) -> String? {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? nil : trimmedValue
    }

    private func uploadDateText(for date: Date) -> String {
        date.formatted(date: .numeric, time: .omitted)
    }
}

#Preview {
    FeaturedView()
        .modelContainer(sharedModelContainer)
}
