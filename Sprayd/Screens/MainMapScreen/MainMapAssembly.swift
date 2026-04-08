//
//  MainMapAssembly.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import SwiftUI
import SwiftData
import MapKit

struct MainMapAssembly {
    let modelContext: ModelContext

    func build() -> some View {
        let coord = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        var items: [ArtItem] = []
        for i in 1...50 {
            items.append(
                ArtItem(
                    remoteID: UUID(), name: "Москва\(i)",
                    itemDescription: "Большой мурал в центре города",
                    images: [ArtImage(remoteID: UUID(), urlString: "https://picsum.photos/id/\(i)/200/300")],
                    location: "Moscow",
                    author: "aboba", // UUID(),
                    state: .new,
                    category: "Mural",
                    latitude: 55.7558 + Double(Int.random(in: 1...100)) / 10000,
                    longitude: 37.6176 + Double(Int.random(in: 1...100)) / 10000
                )
            )
        }
        
        let viewModel = MainMapViewModel(
            modelContext: modelContext,
            region: coord,
            items: items
        )
        return MainMapView(viewModel: viewModel)
    }
}
