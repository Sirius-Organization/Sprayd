//
//  ArtAdditionService.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation
import UIKit

final class ArtAdditionService {
    // MARK: - Fields
    private let sender: Sender
    private let tokenStore: SessionTokenStoring

    // MARK: - Lifecycle
    init(
        sender: Sender,
        tokenStore: SessionTokenStoring
    ) {
        self.sender = sender
        self.tokenStore = tokenStore
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

    func uploadImage(
        itemID: UUID,
        imageData: Data
    ) async throws -> ArtImageResponse {
        guard let token = tokenStore.token()?.trimmingCharacters(in: .whitespacesAndNewlines),
              !token.isEmpty else {
            throw APIError.invalidRequest
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let body = makeMultipartImageBody(
            imageData: imageData,
            boundary: boundary
        )

        return try await sender.send(
            endpoint: "/art-items/\(itemID.uuidString)/images",
            method: .post,
            headers: [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": "Bearer \(token)"
            ],
            body: body
        )
    }

    private func makeMultipartImageBody(imageData: Data, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8) ?? Data())
        body.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8) ?? Data())
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8) ?? Data())
        body.append(imageData)
        body.append(lineBreak.data(using: .utf8) ?? Data())
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8) ?? Data())

        return body
    }
}
