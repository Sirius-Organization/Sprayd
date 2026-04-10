import SwiftUI

extension FeaturedView {
    var searchBar: some View {
        SearchBarView(
            placeholder: "Search for an art object",
            text: $searchText,
            textInputAutocapitalization: .never,
            onFocusChange: { isFocused in
                isSearchFocused = isFocused
            }
        )
    }

    @ViewBuilder
    var feedSections: some View {
        let featuredItem = featuredItem
        let cityPreviews = cities
        let discoverItems = discoverItems

        if let featuredItem {
            VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                sectionTitle("Featured")
                featuredCard(item: featuredItem)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelectItem(featuredItem)
                    }
            }
            .entrance(isVisible: hasAppeared, delay: Motion.Delay.section)
        }

        if !cityPreviews.isEmpty {
            VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                sectionTitle("Cities")
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: Metrics.oneAndHalfModule) {
                        ForEach(cityPreviews) { city in
                            NavigationLink {
                                CityScreenView(city: city.title)
                            } label: {
                                cityCard(
                                    title: city.title,
                                    imageURL: city.imageURL
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.trailing, Metrics.module)
                }
            }
            .entrance(isVisible: hasAppeared, delay: Motion.Delay.section * 2)
        }

        if !discoverItems.isEmpty {
            VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                sectionTitle("Discover")

                if let first = discoverItems.first {
                    discoverLargeCard(item: first)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelectItem(first)
                        }
                    .padding(.bottom, Metrics.module)
                }

                LazyVGrid(columns: gridColumns, spacing: Metrics.doubleModule) {
                    ForEach(Array(discoverItems.dropFirst().enumerated()), id: \.offset) { _, item in
                        discoverSmallCard(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelectItem(item)
                            }
                    }
                }
            }
            .entrance(isVisible: hasAppeared, delay: Motion.Delay.section * 3)
        }

        if items.isEmpty {
            emptyState
                .entrance(isVisible: hasAppeared, delay: Motion.Delay.section)
        }
    }

    var searchResultsCountText: String {
        let count = searchResults.count
        let suffix = count == 1 ? "" : "s"
        return "\(count) result\(suffix) for \"\(trimmedSearchQuery)\""
    }

    @ViewBuilder
    var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            sectionTitle("Search")

            if trimmedSearchQuery.isEmpty {
                searchIdleState
            } else if isSearching {
                searchLoadingState
            } else if let searchErrorMessage {
                stateCard(
                    title: "Search unavailable",
                    message: searchErrorMessage
                )
            } else if searchResults.isEmpty {
                stateCard(
                    title: "Nothing found",
                    message: "No art objects matched \"\(trimmedSearchQuery)\"."
                )
            } else {
                Text(searchResultsCountText)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.secondaryColor)

                LazyVStack(spacing: Metrics.doubleModule) {
                    ForEach(searchResults) { item in
                        discoverLargeCard(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelectItem(item)
                            }
                    }
                }
            }
        }
        .entrance(isVisible: true, delay: Motion.Delay.section)
    }

    var searchIdleState: some View {
        stateCard(
            title: "Search mode",
            message: "Start typing to find an art object by name or description."
        )
    }

    var searchLoadingState: some View {
        HStack(spacing: Metrics.module) {
            ProgressView()
                .tint(Color.appPrimaryText)

            Text("Searching...")
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)

            Spacer()
        }
        .padding(Metrics.doubleModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.14), lineWidth: 1)
        )
    }

    @MainActor
    func performSearch(for query: String) async {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            isSearching = false
            searchResults = []
            searchErrorMessage = nil
            return
        }

        isSearching = true
        searchErrorMessage = nil
        defer { isSearching = false }

        do {
            try await Task.sleep(nanoseconds: Motion.Duration.searchDebounce)
        } catch {
            return
        }

        do {
            let service = ArtSyncService(modelContext: modelContext)
            let results = try await service.searchArtItems(matching: normalizedQuery)
            guard !Task.isCancelled else { return }
            searchResults = results
        } catch {
            guard !Task.isCancelled else { return }
            searchResults = []
            searchErrorMessage = message(for: error)
        }
    }

    func message(for error: Error) -> String {
        if let responseError = error as? APIErrorResponse {
            return responseError.errorMessage
        }

        if error is APIError {
            return "Search is temporarily unavailable. Try again."
        }

        return error.localizedDescription
    }
}
