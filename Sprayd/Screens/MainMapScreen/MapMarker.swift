//
//  MapMarker.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import CoreLocation

struct MapMarker: Identifiable, Hashable {
    let id: UUID
    let title: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(
        id: UUID = UUID(),
        title: String,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) {
        self.id = id
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}
