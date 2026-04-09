//
//  ArtImageResponse.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

struct ArtImageResponse: Codable {
    let id: UUID?
    let artItemId: UUID
    let url: String
    let date: Date
    let timeStamp: TimeInterval
    let userId: UUID
}
