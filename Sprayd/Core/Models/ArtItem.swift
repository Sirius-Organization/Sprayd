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
    var imageUrls: [String]
    var location: String
    @Attribute(originalName: "author") var createdBy: String
    var uploadedBy: String?
    @Attribute(originalName: "createdAt") var uploadedAt: Date
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
        uploadedAt: Date = .now,
        state: ArtState = .new,
        category: String = "",
        likesCount: Int = 0,
        latitude: Double = 0,
        longitude: Double = 0
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.images = storedImages
        self.imageUrls = images
        self.location = location
        self.createdBy = author
        self.uploadedBy = uploadedBy
        self.uploadedAt = uploadedAt
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

    var author: String {
        get { createdBy }
        set { createdBy = newValue }
    }

    var primaryImageURL: URL? {
        let candidates = imageUrls + images.map(\.urlString)

        for candidate in candidates {
            let value = candidate.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty else { continue }
            if let url = URL(string: value) {
                return url
            }
        }

        return nil
    }

    var resolvedUploadedBy: String {
        let value = uploadedBy?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? createdBy : value
    }
}
