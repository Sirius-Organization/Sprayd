//
//  MainMapViewModel.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

@Observable
final class MainMapViewModel {
    var position: MapCameraPosition
    var markers: [MapMarker]

    init(
        position: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        ),
        markers: [MapMarker] = [
            MapMarker(title: "Москва", latitude: 55.7558, longitude: 37.6176)
        ]
    ) {
        self.position = position
        self.markers = markers
    }
}
