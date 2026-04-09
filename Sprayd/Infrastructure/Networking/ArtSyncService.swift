//
//  ArtSyncService.swift
//  Sprayd
//
//  Created by Egor on 08.04.2026.
//

import Foundation
import SwiftData
import CryptoKit

@MainActor
final class ArtSyncService {

    private enum Constants {
        static let artItemsEndpoint = "/art-items"
    }

    private let modelContext: ModelContext
    private let sender: Sender

    init(
        modelContext: ModelContext,
        sender: Sender = Sender()
    ) {
        self.modelContext = modelContext
        self.sender = sender
    }

    func syncArtItems() async throws {
        let remoteItems: [RemoteArtItemResponse] = try await sender.send(
            endpoint: Constants.artItemsEndpoint,
            method: .get
        )

        let remoteIDs = Set(remoteItems.map(\.id))
        let localItems = try fetchAllLocalItems()

        for remoteItem in remoteItems {
            let localItem = try fetchLocalItem(by: remoteItem.id) ?? makeLocalItem(from: remoteItem)
            apply(remoteItem, to: localItem)
            syncImages(for: remoteItem, localItem: localItem)
        }

        for localItem in localItems where !remoteIDs.contains(localItem.id) {
            modelContext.delete(localItem)
        }

        try modelContext.save()
    }

    private func makeLocalItem(from remote: RemoteArtItemResponse) -> ArtItem {
        let item = ArtItem(
            id: remote.id,
            name: remote.name,
            itemDescription: remote.itemDescription,
            images: [],
            location: remote.location,
            author: remote.author,
            uploadedBy: nil,
            createdAt: .now,
            state: remote.state,
            category: remote.category,
            likesCount: 0,
            latitude: remote.latitude,
            longitude: remote.longitude
        )
        modelContext.insert(item)
        return item
    }

    private func apply(_ remote: RemoteArtItemResponse, to localItem: ArtItem) {
        localItem.name = remote.name
        localItem.itemDescription = remote.itemDescription
        localItem.location = remote.location
        localItem.author = remote.author
        localItem.state = remote.state
        localItem.category = remote.category
        localItem.latitude = remote.latitude
        localItem.longitude = remote.longitude
    }

    private func syncImages(for remote: RemoteArtItemResponse, localItem: ArtItem) {
        let imageURLs = remote.imageURLs
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let remoteIDs = Set(imageURLs.map(stableUUID(for:)))

        let imagesToDelete = localItem.images.filter { !remoteIDs.contains($0.id) }
        for image in imagesToDelete {
            modelContext.delete(image)
        }

        localItem.images.removeAll { !remoteIDs.contains($0.id) }

        for urlString in imageURLs {
            let remoteID = stableUUID(for: urlString)

            if let existingImage = localItem.images.first(where: { $0.id == remoteID }) {
                existingImage.urlString = urlString
            } else {
                let image = ArtImage(id: remoteID, urlString: urlString)
                modelContext.insert(image)
                localItem.images.append(image)
            }
        }
    }

    private func stableUUID(for value: String) -> UUID {
        let digest = Insecure.MD5.hash(data: Data(value.utf8))
        let bytes = Array(digest)
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }

    private func fetchAllLocalItems() throws -> [ArtItem] {
        try modelContext.fetch(FetchDescriptor<ArtItem>())
    }

    private func fetchLocalItem(by remoteID: UUID) throws -> ArtItem? {
        let descriptor = FetchDescriptor<ArtItem>(
            predicate: #Predicate<ArtItem> { item in
                item.id == remoteID
            }
        )
        return try modelContext.fetch(descriptor).first
    }
}

private struct RemoteArtItemResponse: Codable {
    let id: UUID
    let name: String
    let itemDescription: String
    let location: String
    let author: String
    let state: ArtState
    let category: String
    let latitude: Double
    let longitude: Double
    let firstImageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case itemDescription
        case description
        case location
        case author
        case state
        case stateRawValue
        case category
        case latitude
        case longitude
        case firstImageUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        firstImageUrl = try container.decodeIfPresent(String.self, forKey: .firstImageUrl)

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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encode(location, forKey: .location)
        try container.encode(author, forKey: .author)
        try container.encode(state.rawValue, forKey: .state)
        try container.encode(category, forKey: .category)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(firstImageUrl, forKey: .firstImageUrl)
    }

    var imageURLs: [String] {
        guard let firstImageUrl else { return [] }
        return [firstImageUrl]
    }
}
