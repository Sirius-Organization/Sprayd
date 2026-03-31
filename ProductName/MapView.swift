//
//  MapView.swift
//  ProductName
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )

    var body: some View {
        Map(position: $position) {
            Marker("Москва", coordinate: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MapView()
}
