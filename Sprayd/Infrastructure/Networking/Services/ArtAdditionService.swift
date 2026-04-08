//
//  ArtAdditionService.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

final class ArtAdditionService {
    // MARK: - Fields
    private let sender: Sender

    // MARK: - Lifecycle
    init(sender: Sender) {
        self.sender = sender
    }

    // MARK: - Networking logic
    func fetchArtists() async throws -> [ArtistResponse] {
        try await sender.send(
            endpoint: "/artists",
            method: .get
        )
    }

    func fetchCategories() async throws -> [CategoryResponse] {
        try await sender.send(
            endpoint: "/categories",
            method: .get
        )
    }

    func createArtItem(request: CreateArtItemRequest) async throws -> ArtItemResponse {
        let body = try JSONEncoder().encode(request)
        return try await sender.send(
            endpoint: "/art-items",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }
}

struct ArtistResponse: Codable {
    let id: UUID?
    let name: String
    let bio: String
    let imagePath: String?
}

struct CategoryResponse: Codable {
    let id: UUID?
    let name: String
    let slug: String
}

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
