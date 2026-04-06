//
//  SwiftData.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import Foundation
import SwiftData

@Model
final class ArtItem {
    var name: String
    var itemDescription: String
    @Relationship(deleteRule: .cascade) var images: [ArtImage]
    var location: String
    @Attribute(originalName: "author") var createdBy: String
    var uploadedBy: String?
    @Attribute(originalName: "createdAt") var uploadedAt: Date
    var stateRawValue: String
    var category: String
    var likesCount: Int

    init(
        name: String = "",
        itemDescription: String = "",
        images: [ArtImage] = [],
        location: String = "",
        createdBy: String = "",
        uploadedBy: String? = nil,
        uploadedAt: Date = .now,
        state: ArtState = .new,
        category: String = "",
        likesCount: Int = 0
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.images = images
        self.location = location
        self.createdBy = createdBy
        self.uploadedBy = uploadedBy
        self.uploadedAt = uploadedAt
        self.stateRawValue = state.rawValue
        self.category = category
        self.likesCount = likesCount
    }

    var state: ArtState {
        get { ArtState(rawValue: stateRawValue) ?? .new }
        set { stateRawValue = newValue.rawValue }
    }

    var resolvedUploadedBy: String {
        let value = uploadedBy?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? createdBy : value
    }
}

@Model
final class ArtImage {
    @Attribute(.externalStorage) var img: Data
    var date: Date
    var timeStamp: TimeInterval
    var userId: UUID

    init(
        img: Data = Data(),
        date: Date = .now,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        userId: UUID = UUID()
    ) {
        self.img = img
        self.date = date
        self.timeStamp = timeStamp
        self.userId = userId
    }
}

enum ArtState: String, Codable, CaseIterable {
    case new
    case exists
    case moderated
}

enum ArtDataStore {
    enum SharedLoadState {
        case ready
        case failed
    }

    static private(set) var sharedLoadState: SharedLoadState = .ready
    static let sharedModelContainer = makeModelContainer(trackSharedLoadState: true)
    static let previewModelContainer = makeModelContainer(
        inMemoryOnly: true,
        seedSampleData: true
    )

    static func makeModelContainer(
        inMemoryOnly: Bool = false,
        seedSampleData: Bool = false,
        trackSharedLoadState: Bool = false
    ) -> ModelContainer {
        let schema = Schema([
            ArtItem.self,
            ArtImage.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemoryOnly
        )

        do {
            let container = try makeContainer(
                schema: schema,
                configuration: configuration,
                seedSampleData: seedSampleData
            )
            if trackSharedLoadState {
                sharedLoadState = .ready
            }
            return container
        } catch {
            guard !inMemoryOnly else {
                fatalError("Failed to create in-memory container: \(error)")
            }

            if trackSharedLoadState {
                sharedLoadState = .failed
            }
            assertionFailure("Failed to create persistent model container: \(error)")

            do {
                let fallbackConfiguration = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true
                )
                return try makeContainer(
                    schema: schema,
                    configuration: fallbackConfiguration,
                    seedSampleData: false
                )
            } catch {
                fatalError("Failed to create fallback in-memory container: \(error)")
            }
        }
    }

    private static func makeContainer(
        schema: Schema,
        configuration: ModelConfiguration,
        seedSampleData: Bool
    ) throws -> ModelContainer {
        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        if seedSampleData {
            try seedIfNeeded(in: container)
        }

        return container
    }

    private static func seedIfNeeded(in container: ModelContainer) throws {
        let context = ModelContext(container)

        guard try context.fetchCount(FetchDescriptor<ArtItem>()) == 0 else {
            return
        }

        makeSeedItems().forEach(context.insert)
        try context.save()
    }

    private static func makeSeedItems(referenceDate: Date = .now) -> [ArtItem] {
        [
            ArtItem(
                name: "The Gliders",
                itemDescription: "A large-scale mural about movement through a dense urban landscape.",
                location: "St. Petersburg",
                createdBy: "Ana Markov",
                uploadedBy: "Loxxych",
                uploadedAt: referenceDate.addingTimeInterval(-3_600),
                state: .moderated,
                category: "Mural",
                likesCount: 22
            ),
            ArtItem(
                name: "Screams",
                itemDescription: "A distressed character study painted on a concrete underpass wall.",
                location: "Moscow",
                createdBy: "Ana Markov",
                uploadedBy: "Egor Maltsev",
                uploadedAt: referenceDate.addingTimeInterval(-7_200),
                state: .new,
                category: "Graffiti",
                likesCount: 18
            ),
            ArtItem(
                name: "Bird District",
                itemDescription: "A colorful neighborhood intervention inspired by local birds and roofs.",
                location: "Kazan",
                createdBy: "Mira Volnova",
                uploadedBy: "Loxxych",
                uploadedAt: referenceDate.addingTimeInterval(-10_800),
                state: .moderated,
                category: "Street art",
                likesCount: 14
            ),
            ArtItem(
                name: "Cube Signal",
                itemDescription: "Geometric work with a strong contrast palette and industrial rhythm.",
                location: "Yekaterinburg",
                createdBy: "Mira Volnova",
                uploadedBy: "Ana Markov",
                uploadedAt: referenceDate.addingTimeInterval(-14_400),
                state: .exists,
                category: "Installation",
                likesCount: 11
            ),
            ArtItem(
                name: "North Wall",
                itemDescription: "A weathered mural documented after restoration work in spring.",
                location: "Veliky Novgorod",
                createdBy: "Egor Maltsev",
                uploadedBy: "Ana Markov",
                uploadedAt: referenceDate.addingTimeInterval(-18_000),
                state: .exists,
                category: "Mural",
                likesCount: 9
            )
        ]
    }
}
