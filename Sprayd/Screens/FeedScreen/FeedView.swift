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
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    searchBar

                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Featured")
                        featuredCard(item: featuredItem)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Cities")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(cities, id: \.self) { city in
                                    cityCard(title: city)
                                }
                            }
                            .padding(.trailing, 8)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Discover")

                        if let first = discoverItems.first {
                            discoverLargeCard(item: first)
                                .padding(.bottom, 8)
                        }

                        LazyVGrid(columns: gridColumns, spacing: 18) {
                            ForEach(Array(discoverItems.dropFirst().enumerated()), id: \.offset) { _, item in
                                discoverSmallCard(item: item)
                            }
                        }
                    }

                    Color.clear
                        .frame(height: 16)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 16)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.gray)

            Text("Search for an art object")
                .font(.system(size: 12))
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding(.horizontal, 14)
        .frame(height: 42)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.5))
                .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 28, weight: .black, design: .rounded))
            .foregroundStyle(.black)
    }

    private func featuredCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            imagePlaceholder(height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black)

                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.gray.opacity(0.45))
                            .frame(width: 18, height: 18)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.white)
                            }

                        Text(item.author)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.black.opacity(0.8))
                    }
                }

                Spacer()

                likesView(count: 22)
                    .padding(.top, 6)
            }
        }
    }

    private func cityCard(title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))
                .frame(width: 74, height: 78)

            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.75))
            }
        }
        .frame(width: 90, alignment: .leading)
    }

    private func discoverLargeCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            imagePlaceholder(height: 192)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)

                        Text(item.location)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.gray)
                    }
                }

                Spacer()

                likesView(count: 22)
                    .padding(.top, 6)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.35), lineWidth: 1)
        )
    }

    private func discoverSmallCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            imagePlaceholder(height: 122)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.gray.opacity(0.45))
                            .frame(width: 16, height: 16)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 7))
                                    .foregroundStyle(.white)
                            }

                        Text(item.author)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.black.opacity(0.8))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 6)

                likesView(count: 22)
                    .scaleEffect(0.9, anchor: .topTrailing)
            }
        }
    }

    private func likesView(count: Int) -> some View {
        HStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.black)

            Image(systemName: "heart")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.accentRed)
        }
    }

    private func imagePlaceholder(height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.16))

            Image(systemName: "photo")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(.gray.opacity(0.7))
        }
        .frame(height: height)
    }
}

#Preview {
    FeaturedView()
}
