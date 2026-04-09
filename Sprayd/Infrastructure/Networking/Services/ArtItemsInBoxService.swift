//
//  ArtItemsInBoxService.swift
//  Sprayd
//
//  Created by User on 08.04.2026.
//

import Foundation
import MapKit
import SwiftData

struct MapBoundingBox: Hashable {
    let minLongitude: Double
    let minLatitude: Double
    let maxLongitude: Double
    let maxLatitude: Double

    init(region: MKCoordinateRegion) {
        minLongitude = region.center.longitude - region.span.longitudeDelta
        minLatitude = region.center.latitude - region.span.latitudeDelta
        maxLongitude = region.center.longitude + region.span.longitudeDelta
        maxLatitude = region.center.latitude + region.span.latitudeDelta
    }

    var queryValue: String {
        "\(minLongitude),\(minLatitude),\(maxLongitude),\(maxLatitude)"
    }

    func contains(_ other: MapBoundingBox) -> Bool {
        other.minLongitude >= minLongitude &&
        other.maxLongitude <= maxLongitude &&
        other.minLatitude >= minLatitude &&
        other.maxLatitude <= maxLatitude
    }
}

@MainActor
final class ArtItemsInBoxService {
    private let sender: Sender
    private let modelContext: ModelContext

    init(sender: Sender, modelContext: ModelContext) {
        self.sender = sender
        self.modelContext = modelContext
    }

    func loadArtItems(in region: MKCoordinateRegion) async -> [ArtItem] {
        let boundingBox = MapBoundingBox(region: region)

        do {
            let responses: [ArtItemResponse] = try await sender.send(
                endpoint: "/art-items/in-box?bbox=\(boundingBox.queryValue)",
                method: .get
            )

            let items = try upsertResponses(responses)
            return items
        } catch {
            return fetchCachedItems(in: boundingBox)
        }
    }

    private func upsertResponses(_ responses: [ArtItemResponse]) throws -> [ArtItem] {
        var items: [ArtItem] = []
        items.reserveCapacity(responses.count)

        for response in responses {
            let mappedItem = ArtAdditionMapper.mapArtItem(response)

            if let cachedItem = try fetchCachedItem(for: response) {
                update(cachedItem, with: mappedItem, remoteID: response.id)
                items.append(cachedItem)
            } else {
                modelContext.insert(mappedItem)
                items.append(mappedItem)
            }
        }

        if modelContext.hasChanges {
            try modelContext.save()
        }

        return items
    }

    private func fetchCachedItems(in boundingBox: MapBoundingBox) -> [ArtItem] {
        let minLatitude = boundingBox.minLatitude
        let maxLatitude = boundingBox.maxLatitude
        let minLongitude = boundingBox.minLongitude
        let maxLongitude = boundingBox.maxLongitude

        let descriptor = FetchDescriptor<ArtItem>(
            predicate: #Predicate<ArtItem> { item in
                item.latitude >= minLatitude &&
                item.latitude <= maxLatitude &&
                item.longitude >= minLongitude &&
                item.longitude <= maxLongitude
            }
        )

        return (try? modelContext.fetch(descriptor)) ?? []
    }

    private func fetchCachedItem(for response: ArtItemResponse) throws -> ArtItem? {
        if let remoteID = response.id {
            let byID = FetchDescriptor<ArtItem>(
                predicate: #Predicate<ArtItem> { item in
                    item.id == remoteID
                }
            )

            if let item = try modelContext.fetch(byID).first {
                return item
            }
        }

        let name = response.name
        let author = response.author
        let latitude = response.latitude
        let longitude = response.longitude

        let byContent = FetchDescriptor<ArtItem>(
            predicate: #Predicate<ArtItem> { item in
                item.name == name &&
                item.author == author &&
                item.latitude == latitude &&
                item.longitude == longitude
            }
        )

        return try modelContext.fetch(byContent).first
    }

    private func update(_ item: ArtItem, with mappedItem: ArtItem, remoteID: UUID?) {
        if let remoteID {
            item.id = remoteID
        }

        item.name = mappedItem.name
        item.itemDescription = mappedItem.itemDescription
        item.location = mappedItem.location
        item.author = mappedItem.author
        item.state = mappedItem.state
        item.category = mappedItem.category
        item.latitude = mappedItem.latitude
        item.longitude = mappedItem.longitude

        let remoteImages = mappedItem.images.map { image in
            RemoteArtImagePayload(
                remoteID: nil,
                urlString: image.urlString,
                createdAt: nil,
                timeStamp: nil,
                userID: nil
            )
        }

        ArtItemImageMerger.merge(
            remoteImages,
            into: item,
            modelContext: modelContext,
            mode: .preserveExisting
        )
    }
}
