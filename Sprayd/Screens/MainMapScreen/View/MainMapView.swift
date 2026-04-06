//
//  MainMapView.swift
//  Sprayd
//
//  Created by User on 02.04.2026.
//

import SwiftUI

struct MainMapView: View {
    @State private var viewModel: MainMapViewModel

    init(viewModel: MainMapViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        UIKitMapView(
            region: viewModel.region,
            items: viewModel.items,
            imageProvider: { urlString in
                await viewModel.imageData(for: urlString)
            }
        )
        .ignoresSafeArea()
    }
}
