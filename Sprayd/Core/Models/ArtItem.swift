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
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String
    @Relationship(deleteRule: .cascade) var images: [ArtImage]
    var location: String
    var author: String
    var uploadedBy: String?
    var createdAt: Date
    var createdDate: Date?
    var stateRawValue: String
    var category: String
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double

    init(
        id: UUID = UUID(),
        name: String = "",
        itemDescription: String = "",
        images: [ArtImage] = [],
        location: String = "",
        author: String = "",
        uploadedBy: String? = nil,
        createdAt: Date = .now,
        createdDate: Date? = nil,
        state: ArtState = .new,
        category: String = "",
        isFavorite: Bool = false,
        latitude: Double = 0,
        longitude: Double = 0
    ) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.images = images
        self.location = location
        self.author = author
        self.uploadedBy = uploadedBy
        self.createdAt = createdAt
        self.createdDate = createdDate
        self.stateRawValue = state.rawValue
        self.category = category
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
    }

    var state: ArtState {
        get { ArtState(rawValue: stateRawValue) ?? .new }
        set { stateRawValue = newValue.rawValue }
    }

    var orderedImages: [ArtImage] {
        images.sorted(by: Self.isImage(_:before:))
    }

    var primaryImageURL: URL? {
        for image in orderedImages {
            let value = image.urlString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty else { continue }
            if let url = URL(string: value) {
                return url
            }
        }

        return nil
    }

    var cityName: String? {
        let parts = location
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return parts.last
    }

    private static func isImage(_ lhs: ArtImage, before rhs: ArtImage) -> Bool {
        if lhs.timeStamp != rhs.timeStamp {
            return lhs.timeStamp < rhs.timeStamp
        }

        if lhs.createdAt != rhs.createdAt {
            return lhs.createdAt < rhs.createdAt
        }

        let lhsURL = lhs.urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        let rhsURL = rhs.urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        if lhsURL != rhsURL {
            return lhsURL.localizedStandardCompare(rhsURL) == .orderedAscending
        }

        return lhs.id.uuidString < rhs.id.uuidString
    }
}
