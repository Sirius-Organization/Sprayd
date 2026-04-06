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
