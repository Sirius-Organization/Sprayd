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
    @Relationship(deleteRule: .cascade) var images: [ArtImage]
    var location: String
    var author: String
    var stateRawValue: String
    var category: String

    init(
        name: String = "",
        itemDescription: String = "",
        images: [ArtImage] = [],
        location: String = "",
        author: String = "",
        state: ArtState = .new,
        category: String = ""
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.images = images
        self.location = location
        self.author = author
        self.stateRawValue = state.rawValue
        self.category = category
    }

    var state: ArtState {
        get { ArtState(rawValue: stateRawValue) ?? .new }
        set { stateRawValue = newValue.rawValue }
    }
}

@Model
final class ArtImage {
    @Attribute(.externalStorage) var img: Data
    var date: Date
    var timeStamp: TimeInterval
    var userId: UUID

    init(
        img: Data = Data(),
        date: Date = .now,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        userId: UUID = UUID()
    ) {
        self.img = img
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
