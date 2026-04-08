//
//  ArtImage.swift
//  Sprayd
//
//  Created by User on 04.04.2026.
//

import Foundation
import SwiftData

@Model
final class ArtImage {
    @Attribute(.unique) var id: UUID
    var urlString: String
    var createdAt: Date
    var timeStamp: TimeInterval
    var userID: UUID?

    init(
        id: UUID = UUID(),
        urlString: String = "",
        createdAt: Date = .now,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        userID: UUID? = nil
    ) {
        self.id = id
        self.urlString = urlString
        self.createdAt = createdAt
        self.timeStamp = timeStamp
        self.userID = userID
    }
}
