//
//  FeaturedView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI

struct FeaturedView: View {
    
    private let featuredItem = ArtItem(
        name: "The Gliders",
        itemDescription: "",
        images: [],
        location: "St.Petersburg",
        author: "Ana Markov",
        state: .new,
        category: ""
    )

    private let cities = ["Moscow", "Moscow", "Moscow"]

    private let discoverItems: [ArtItem] = [
        ArtItem(
            name: "The Gliders",
            itemDescription: "",
            images: [],
            location: "St.Petersburg",
            author: "Ana Markov",
            state: .new,
            category: ""
        ),
        ArtItem(
            name: "Screams",
            itemDescription: "",
            images: [],
            location: "",
            author: "Ana Markov",
            state: .new,
            category: ""
        ),
        ArtItem(
            name: "Screams",
            itemDescription: "",
            images: [],
            location: "",
            author: "Ana Markov",
            state: .new,
            category: ""
        ),
        ArtItem(
            name: "Screams",
            itemDescription: "",
            images: [],
            location: "",
            author: "Ana Markov",
            state: .new,
            category: ""
        ),
        ArtItem(
            name: "Screams",
            itemDescription: "",
            images: [],
            location: "",
            author: "Ana Markov",
            state: .new,
            category: ""
        )
    ]

    private let gridColumns = [
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule),
        GridItem(.flexible(), spacing: Metrics.oneAndHalfModule)
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.tripleModule) {
                    searchBar

                    VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                        sectionTitle("Featured")
                        featuredCard(item: featuredItem)
                    }

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

                    Color.clear
                        .frame(height: Metrics.doubleModule)
                }
                .padding(.horizontal, Metrics.tripleModule)
                .padding(.top, Metrics.oneAndHalfModule)
                .padding(.bottom, Metrics.oneAndHalfModule)
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
            imagePlaceholder(height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold20)
                        .foregroundStyle(.black)

                    HStack(spacing: Metrics.module) {
                        Circle()
                            .fill(Color.gray.opacity(0.45))
                            .frame(width: 24, height: 24)
                            .overlay {
                                Icons.person
                                    .font(.system(size: 8))
                            }

                        Text(item.author)
                            .font(.InstrumentMedium13)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                }

                Spacer()

                likesView(count: 22)
                    .padding(.top, Metrics.module)
            }
        }
    }

    private func cityCard(title: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))
                .frame(width: 74, height: 78)

            HStack(spacing: Metrics.module) {
                Text(title)
                    .font(.InstrumentBold17)
                    .foregroundStyle(.black)

                Icons.chevronRight
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.75))
            }
        }
        .frame(width: 90, alignment: .leading)
    }

    private func discoverLargeCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            imagePlaceholder(height: 192)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(Font.InstrumentBold20)
                        .foregroundStyle(.black)

                    HStack(spacing: Metrics.halfModule) {
                        Icons.location
                            .frame(width: Metrics.oneAndHalfModule, height: Metrics.oneAndHalfModule)

                        Text(item.location)
                            .font(.InstrumentMedium13)
                            .foregroundStyle(.gray)
                    }
                }

                Spacer()

                likesView(count: 22)
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
            imagePlaceholder(height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold17)
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    HStack(spacing: Metrics.halfModule) {
                        Circle()
                            .fill(Color.gray.opacity(0.45))
                            .frame(width: 16, height: 16)
                            .overlay {
                                Icons.person
                                    .font(.system(size: 7))
                            }

                        Text(item.author)
                            .font(.InstrumentMedium10)
                            .foregroundStyle(.black.opacity(0.8))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: Metrics.module)

                likesView(count: 22)
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

    private func imagePlaceholder(height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))

            Icons.photo
                .foregroundStyle(.gray.opacity(0.7))
                .font(.system(size: 34, weight: .medium))
        }
        .frame(height: height)
    }
}

#Preview {
    FeaturedView()
}
