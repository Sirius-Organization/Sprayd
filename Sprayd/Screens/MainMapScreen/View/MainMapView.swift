//
//  MainMapView.swift
//  Sprayd
//
//  Created by User on 02.04.2026.
//

import SwiftUI

struct MainMapView: View {
    @State private var viewModel: MainMapViewModel
    @State private var selectedItem: ArtItem?
    @State private var selectedDetent: PresentationDetent = .fraction(0.5)

    init(viewModel: MainMapViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        UIKitMapView(
            region: viewModel.region,
            items: viewModel.items,
            isItemSheetPresented: selectedItem != nil,
            onSelectItem: { item in
                selectedDetent = .fraction(0.5)
                selectedItem = item
            }
        )
        .ignoresSafeArea()
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
                ArtMediumCardView(item: selectedItem)
                    .presentationDetents(
                        [.fraction(0.5), .large],
                        selection: $selectedDetent
                    )
                    .presentationDragIndicator(.visible)
                    .scrollDisabled(true)
            }
        }
    }
}
