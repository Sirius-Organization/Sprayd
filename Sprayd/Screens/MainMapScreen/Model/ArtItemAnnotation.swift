//
//  ArtItemAnnotation.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit

final class ArtItemAnnotation: NSObject, MKAnnotation {
    let item: ArtItem
    let itemIdentifier: ObjectIdentifier

    let coordinate: CLLocationCoordinate2D

    let title: String?

    let subtitle: String?

    let imageURL: URL?

    init(item: ArtItem) {
        self.item = item
        self.itemIdentifier = ObjectIdentifier(item)
        self.coordinate = CLLocationCoordinate2D(
            latitude: item.latitude,
            longitude: item.longitude
        )
        self.title = item.name
        self.subtitle = item.author
        self.imageURL = item.primaryImageURL
        super.init()
    }
}
