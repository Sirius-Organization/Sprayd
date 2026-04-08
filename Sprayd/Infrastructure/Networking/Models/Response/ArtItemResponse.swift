//
//  ArtItemResponse.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

struct ArtItemResponse: Codable {
    let id: UUID?
    let name: String
    let itemDescription: String
    let location: String
    let latitude: Double
    let longitude: Double
    let author: String
    let state: String
    let category: String
    let firstImageUrl: String?
}
