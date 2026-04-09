//
//  MainMapView.swift
//  Sprayd
//
//  Created by User on 02.04.2026.
//

import SwiftUI
import TipKit

struct MainMapView: View {
    @State private var viewModel: MainMapViewModel
    @State private var selectedItem: ArtItem?
    @State private var selectedDetent: PresentationDetent = .fraction(0.5)
    private let mapTip = MapTip()
    private let onSelectItem: (ArtItem) -> Void

    init(
        viewModel: MainMapViewModel,
        onSelectItem: @escaping (ArtItem) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onSelectItem = onSelectItem
    }

    var body: some View {
        UIKitMapView(
            startRegion: viewModel.startRegion,
            items: viewModel.items,
            isItemSheetPresented: selectedItem != nil,
            onRegionDidChange: { region in
                viewModel.updateRegion(region)
            },
            onSelectItem: { item in
                selectedDetent = .fraction(0.5)
                selectedItem = item
            }
        )
        .ignoresSafeArea()
        .task {
            await viewModel.loadInitialItemsIfNeeded()
        }
        .sheet(
            isPresented: Binding(
                get: { selectedItem != nil },
                set: { isPresented in
                    if !isPresented {
                        selectedItem = nil
                    }
                }
            )
        ) {
            if let selectedItem {
                ArtMediumCardView(
                    item: selectedItem,
                    onOpenDetails: {
                        let item = selectedItem
                        self.selectedItem = nil
                        onSelectItem(item)
                    }
                )
                    .presentationDetents(
                        [.fraction(0.5), .large],
                        selection: $selectedDetent
                    )
                    .presentationDragIndicator(.visible)
                    .scrollIndicators(.hidden)
            }
        }
        .safeAreaInset(edge: .top) {
            TipView(MapTip(), arrowEdge: .top)
                .padding(.horizontal)
        }
        .onTapGesture {
            Task {
                await TipEvents.firstClosed.donate()
            }
        }
    }
}
