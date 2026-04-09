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
    let onSelectItem: (ArtItem) -> Void

    func build() -> some View {
        let coord = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )

        let viewModel = MainMapViewModel(
            region: coord,
            items: [],
            artItemsInBoxService: artItemsInBoxService
        )
        return MainMapView(
            viewModel: viewModel,
            onSelectItem: onSelectItem
        )
    }
}
