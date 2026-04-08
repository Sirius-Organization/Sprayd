//
//  CreateArtItemResponse.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

struct CreateArtItemRequest: Codable {
    let name: String
    let itemDescription: String
    let location: String
    let latitude: Double
    let longitude: Double
    let author: String
    let state: String
    let category: String
}
