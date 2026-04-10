import Foundation
import SwiftData
import Testing
@testable import Sprayd

@MainActor
struct ArtItemLogicTests {
    @Test
    func cityNameUsesLastNonEmptyLocationComponent() {
        let item = ArtItem(
            name: "Item",
            itemDescription: "Description",
            location: "ул. Ленина, 8, Yekaterinburg",
            author: "Author",
            category: "Mural"
        )

        #expect(item.cityName == "Yekaterinburg")
    }

    @Test
    func orderedImagesUsesStableSortOrder() {
        let item = ArtItem(
            name: "Item",
            itemDescription: "Description",
            images: [
                ArtImage(
                    urlString: "https://example.com/c.jpg",
                    createdAt: Date(timeIntervalSince1970: 50),
                    timeStamp: 2
                ),
                ArtImage(
                    urlString: "https://example.com/b.jpg",
                    createdAt: Date(timeIntervalSince1970: 10),
                    timeStamp: 1
                ),
                ArtImage(
                    urlString: "https://example.com/a.jpg",
                    createdAt: Date(timeIntervalSince1970: 10),
                    timeStamp: 1
                )
            ],
            location: "Street, City",
            author: "Author",
            category: "Mural"
        )

        #expect(item.orderedImages.map(\.urlString) == [
            "https://example.com/a.jpg",
            "https://example.com/b.jpg",
            "https://example.com/c.jpg"
        ])
    }

    @Test
    func primaryImageURLSkipsEmptyStringsAndReturnsFirstValidURL() {
        let item = ArtItem(
            name: "Item",
            itemDescription: "Description",
            images: [
                ArtImage(urlString: "   "),
                ArtImage(urlString: "https://example.com/primary.jpg"),
                ArtImage(urlString: "https://example.com/other.jpg")
            ],
            location: "Street, City",
            author: "Author",
            category: "Mural"
        )

        #expect(item.primaryImageURL?.absoluteString == "https://example.com/primary.jpg")
    }

    @Test
    func applyPreservesSelectedPhotoWhenItemUpdates() {
        let first = ArtImage(
            urlString: "https://example.com/1.jpg",
            createdAt: Date(timeIntervalSince1970: 10),
            timeStamp: 1
        )
        let second = ArtImage(
            urlString: "https://example.com/2.jpg",
            createdAt: Date(timeIntervalSince1970: 20),
            timeStamp: 2
        )
        let originalItem = ArtItem(
            name: "Item",
            itemDescription: "Description",
            images: [first, second],
            location: "Street, City",
            author: "Author",
            category: "Mural"
        )
        let viewModel = ArtObjectViewModel(item: originalItem)
        viewModel.selectedPhotoIndex = 1

        let updatedItem = ArtItem(
            id: originalItem.id,
            name: "Item",
            itemDescription: "Description",
            images: [
                ArtImage(
                    urlString: "https://example.com/0.jpg",
                    createdAt: Date(timeIntervalSince1970: 5),
                    timeStamp: 0
                ),
                second,
                first
            ],
            location: "Street, City",
            author: "Author",
            category: "Mural"
        )

        viewModel.apply(item: updatedItem)

        #expect(viewModel.photoImageNames[viewModel.selectedPhotoIndex] == "https://example.com/2.jpg")
    }

    @Test
    func preserveExistingImageMergeKeepsLocalImagesAndAppendsNewRemoteOnes() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let retainedImage = ArtImage(
            id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
            urlString: "https://example.com/retained.jpg",
            createdAt: Date(timeIntervalSince1970: 10),
            timeStamp: 1
        )
        let localOnlyImage = ArtImage(
            id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!,
            urlString: "https://example.com/local-only.jpg",
            createdAt: Date(timeIntervalSince1970: 20),
            timeStamp: 2
        )
        let item = ArtItem(
            name: "Item",
            itemDescription: "Description",
            images: [retainedImage, localOnlyImage],
            location: "Street, City",
            author: "Author",
            category: "Mural"
        )
        context.insert(item)

        ArtItemImageMerger.merge(
            [
                RemoteArtImagePayload(
                    remoteID: retainedImage.id,
                    urlString: retainedImage.urlString,
                    createdAt: retainedImage.createdAt,
                    timeStamp: retainedImage.timeStamp,
                    userID: nil
                ),
                RemoteArtImagePayload(
                    remoteID: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC"),
                    urlString: "https://example.com/new-remote.jpg",
                    createdAt: Date(timeIntervalSince1970: 30),
                    timeStamp: 3,
                    userID: nil
                )
            ],
            into: item,
            modelContext: context,
            mode: .preserveExisting
        )

        #expect(item.images.map(\.urlString) == [
            "https://example.com/retained.jpg",
            "https://example.com/new-remote.jpg",
            "https://example.com/local-only.jpg"
        ])
    }

    private func makeModelContainer() throws -> ModelContainer {
        let schema = Schema([
            ArtItem.self,
            ArtImage.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }
}
