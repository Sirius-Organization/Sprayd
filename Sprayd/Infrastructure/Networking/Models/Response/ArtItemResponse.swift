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

struct ArtItemDetailsResponse: Decodable {
    let id: UUID
    let name: String
    let itemDescription: String
    let location: String
    let latitude: Double
    let longitude: Double
    let author: String
    let state: ArtState
    let category: String
    let images: [ArtImageResponse]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case itemDescription
        case description
        case location
        case latitude
        case longitude
        case author
        case state
        case stateRawValue
        case category
        case images
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        images = try container.decodeIfPresent([ArtImageResponse].self, forKey: .images) ?? []

        if let descriptionValue = try container.decodeIfPresent(String.self, forKey: .itemDescription) {
            itemDescription = descriptionValue
        } else if let descriptionValue = try container.decodeIfPresent(String.self, forKey: .description) {
            itemDescription = descriptionValue
        } else {
            itemDescription = ""
        }

        let rawState: String
        if let stateValue = try container.decodeIfPresent(String.self, forKey: .state) {
            rawState = stateValue
        } else if let stateValue = try container.decodeIfPresent(String.self, forKey: .stateRawValue) {
            rawState = stateValue
        } else {
            rawState = ArtState.new.rawValue
        }

        state = ArtState(rawValue: rawState) ?? .new
    }
}
