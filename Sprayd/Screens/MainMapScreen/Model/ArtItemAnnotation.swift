//
//  ArtItemAnnotation.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit

final class ArtItemAnnotation: NSObject, MKAnnotation, ArtMapAnnotation {
    let item: ArtItem

    var itemIdentifier: ObjectIdentifier {
        ObjectIdentifier(item)
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
    }

    var title: String? {
        item.name
    }

    var subtitle: String? {
        item.author
    }

    var imageURL: URL? {
        item.primaryImageURL
    }

    var author: String? {
        item.author
    }

    var itemDescription: String? {
        item.itemDescription
    }

    init(item: ArtItem) {
        self.item = item
    }
}
