//
//  SwiftData.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import Foundation
import SwiftData

@Model
final class ArtItem {
    var name: String
    var itemDescription: String
    var imageUrls: [String]
    var location: String
    var author: String
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
        author: String = "",
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

@Model
final class ArtImage {
    @Attribute(.externalStorage) var img: Data
    var urlString: String
    var date: Date
    var timeStamp: TimeInterval
    var userId: UUID

    init(
        img: Data = Data(),
        urlString: String = "",
        date: Date = .now,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        userId: UUID = UUID()
    ) {
        self.img = img
        self.urlString = urlString
        self.date = date
        self.timeStamp = timeStamp
        self.userId = userId
    }
}

enum ArtState: String, Codable, CaseIterable {
    case new
    case exists
    case moderated
}
