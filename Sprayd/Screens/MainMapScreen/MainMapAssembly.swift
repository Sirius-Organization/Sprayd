//
//  MainMapAssembly.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import SwiftUI
import MapKit

struct MainMapAssembly {
    let artItemsInBoxService: ArtItemsInBoxService
    let locationProvider: LocationProvider

    func build() -> some View {
        let viewModel = MainMapViewModel(
            artItemsInBoxService: artItemsInBoxService,
            locationProvider: locationProvider
        )
        return MainMapView(
            viewModel: viewModel
        )
    }
}
