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
    @Attribute(.unique) var remoteID: UUID
    var urlString: String

    init(remoteID: UUID, urlString: String = "") {
        self.remoteID = remoteID
        self.urlString = urlString
    }
}
