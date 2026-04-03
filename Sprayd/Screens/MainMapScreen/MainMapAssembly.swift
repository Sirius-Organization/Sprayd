//
//  MainMapAssembly.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import SwiftUI
import SwiftData

struct MainMapAssembly {
    let modelContext: ModelContext

    func makeImageLoaderService() -> ImageLoaderService {
        ImageLoaderService(modelContext: modelContext)
    }

    func makeViewModel() -> MainMapViewModel {
        MainMapViewModel(imageLoader: makeImageLoaderService())
    }

    func makeView() -> MainMapView {
        MainMapView(viewModel: makeViewModel())
    }
}
