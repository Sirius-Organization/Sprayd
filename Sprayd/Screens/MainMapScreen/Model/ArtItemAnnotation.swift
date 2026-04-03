//
//  ArtItemAnnotation.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit

final class ArtItemAnnotation: NSObject, MKAnnotation, ArtMapAnnotation {
    private let item: ArtItem
    // Нужны чтобы избежать RE из-за objc runtime
    private let storedTitle: String
    private let storedSubtitle: String

    var itemIdentifier: ObjectIdentifier {
        ObjectIdentifier(item)
    }

    let coordinate: CLLocationCoordinate2D

    var title: String? {
        storedTitle
    }

    var subtitle: String? {
        storedSubtitle
    }

    var imageURL: URL? {
        item.primaryImageURL
    }
    
    var author: String?
    
    var itemDescription: String?
    
    init(item: ArtItem) {
        self.item = item
        coordinate = CLLocationCoordinate2D(
            latitude: item.latitude,
            longitude: item.longitude
        )
        storedTitle = item.name
        storedSubtitle = item.author
    }
}
