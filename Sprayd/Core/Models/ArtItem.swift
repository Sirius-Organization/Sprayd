//
//  ArtItem.swift
//  Sprayd
//
//  Created by User on 04.04.2026.
//

import Foundation
import SwiftData

@Model
final class ArtItem {
    var name: String
    var itemDescription: String
    var imageUrls: [String]
    var location: String
    var author: String // UUID
    var stateRawValue: String
    var category: String
    var latitude: Double
    var longitude: Double

    var state: ArtState {
        get { ArtState(rawValue: stateRawValue) ?? .new }
        set { stateRawValue = newValue.rawValue }
    }

    var primaryImageURL: URL? {
        guard let first = imageUrls.first else { return nil }
        return URL(string: first)
    }

    init(
        name: String = "",
        itemDescription: String = "",
        images: [String] = [],
        location: String = "",
        author: String, // UUID = UUID(),
        state: ArtState = .new,
        category: String = "",
        latitude: Double = 0,
        longitude: Double = 0
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.imageUrls = images
        self.location = location
        self.author = author
        self.stateRawValue = state.rawValue
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
}
