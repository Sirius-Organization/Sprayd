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
    @Relationship(deleteRule: .cascade) var images: [ArtImage]
    var location: String
    var author: String
    var uploadedBy: String?
    var createdAt: Date
    var stateRawValue: String
    var category: String
    var likesCount: Int
    var latitude: Double
    var longitude: Double

    init(
        name: String = "",
        itemDescription: String = "",
        images: [String] = [],
        storedImages: [ArtImage] = [],
        location: String = "",
        author: String = "",
        uploadedBy: String? = nil,
        createdAt: Date = .now,
        state: ArtState = .new,
        category: String = "",
        likesCount: Int = 0,
        latitude: Double = 0,
        longitude: Double = 0
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.images = storedImages + images.map { ArtImage(urlString: $0) }
        self.location = location
        self.author = author
        self.uploadedBy = uploadedBy
        self.createdAt = createdAt
        self.stateRawValue = state.rawValue
        self.category = category
        self.likesCount = likesCount
        self.latitude = latitude
        self.longitude = longitude
    }

    var state: ArtState {
        get { ArtState(rawValue: stateRawValue) ?? .new }
        set { stateRawValue = newValue.rawValue }
    }

    var primaryImageURL: URL? {
        for image in images {
            let value = image.urlString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty else { continue }
            if let url = URL(string: value) {
                return url
            }
        }

        return nil
    }
}
