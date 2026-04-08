//
//  ArtAdditionRepository.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftData
import Foundation

@MainActor
final class ArtAdditionRepository {
    private let service: ArtAdditionService
    private let modelContext: ModelContext

    init(service: ArtAdditionService, modelContext: ModelContext) {
        self.service = service
        self.modelContext = modelContext
    }

    func syncArtists() async throws -> [Author] {
        let responses = try await service.fetchArtists()
        let authors = responses.map(ArtAdditionMapper.mapArtist)
        let existingAuthors = try fetchAuthors()

        for author in authors {
            if let existingAuthor = existingAuthors.first(where: { $0.id == author.id }) {
                existingAuthor.name = author.name
                existingAuthor.bio = author.bio
                existingAuthor.imageURLString = author.imageURLString
            } else {
                modelContext.insert(author)
            }
        }

        try modelContext.save()
        return try fetchAuthors()
    }

    func fetchAuthors() throws -> [Author] {
        let descriptor = FetchDescriptor<Author>(
            sortBy: [SortDescriptor(\Author.name)]
        )
        return try modelContext.fetch(descriptor)
    }

    func createArtItem(
        title: String,
        description: String,
        locationName: String,
        latitude: Double,
        longitude: Double,
        author: Author,
        category: Category
    ) async throws -> ArtItem {
        let response = try await service.createArtItem(
            request: CreateArtItemRequest(
                name: title,
                itemDescription: description,
                location: locationName,
                latitude: latitude,
                longitude: longitude,
                author: author.name,
                state: ArtState.new.rawValue,
                category: category.name
            )
        )

        let mappedItem = ArtAdditionMapper.mapArtItem(response)
        let existingItems = try modelContext.fetch(FetchDescriptor<ArtItem>())

        if let existingItem = existingItems.first(where: { $0.id == mappedItem.id }) {
            existingItem.name = mappedItem.name
            existingItem.itemDescription = mappedItem.itemDescription
            existingItem.location = mappedItem.location
            existingItem.author = mappedItem.author
            existingItem.stateRawValue = mappedItem.stateRawValue
            existingItem.category = mappedItem.category
            existingItem.latitude = mappedItem.latitude
            existingItem.longitude = mappedItem.longitude
            existingItem.images = mappedItem.images
            try modelContext.save()
            return existingItem
        }

        modelContext.insert(mappedItem)
        try modelContext.save()
        return mappedItem
    }
}
