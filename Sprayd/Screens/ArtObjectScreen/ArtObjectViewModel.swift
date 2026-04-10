//
//  ArtObjectViewModel.swift
//  Sprayd
//

import Foundation
import SwiftData

@Observable
final class ArtObjectViewModel {
    // MARK: - Data fields
    var name: String
    var itemDescription: String
    var photoImageNames: [String]
    var location: String
    var author: String
    var category: String
    var postedBy: String
    var dateText: String?

    // MARK: - UI state
    var selectedPhotoIndex: Int = 0
    var isPhotoPreviewPresented: Bool = false
    var isFavorite: Bool = false
    var isVisited: Bool = false
    private var item: ArtItem?

    var itemID: UUID? {
        item?.id
    }

    // MARK: - Init
    init(
        name: String,
        itemDescription: String,
        photoImageNames: [String],
        location: String,
        author: String,
        category: String,
        postedBy: String,
        dateText: String?
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.photoImageNames = photoImageNames
        self.location = location
        self.author = author
        self.category = category
        self.postedBy = postedBy
        self.dateText = dateText
        self.item = nil
    }

    convenience init(item: ArtItem) {
        self.init(
            name: item.name,
            itemDescription: item.itemDescription,
            photoImageNames: Self.makeImageURLs(from: item),
            location: item.location,
            author: item.author,
            category: item.category,
            postedBy: Self.postedByText(from: item),
            dateText: Self.dateText(from: item)
        )

        self.item = item
        isFavorite = item.isFavorite
        isVisited = item.isVisited
    }

    // MARK: - Actions

    func toggleFavorite(in modelContext: ModelContext) {
        let updatedValue = !isFavorite
        isFavorite = updatedValue
        item?.isFavorite = updatedValue

        do {
            try modelContext.save()
        } catch {
            isFavorite.toggle()
            item?.isFavorite = isFavorite
            print("Favorite save error:", error)
        }
    }

    func toggleVisited(in modelContext: ModelContext) {
        let updatedValue = !isVisited
        isVisited = updatedValue
        item?.isVisited = updatedValue

        do {
            try modelContext.save()
        } catch {
            isVisited.toggle()
            item?.isVisited = isVisited
            print("Visited save error:", error)
        }
    }

    func openPhotoPreview(at index: Int) {
        selectedPhotoIndex = index
        isPhotoPreviewPresented = true
    }

    func apply(item: ArtItem) {
        let currentPhoto = photoImageNames.indices.contains(selectedPhotoIndex)
            ? photoImageNames[selectedPhotoIndex]
            : nil

        self.item = item
        name = item.name
        itemDescription = item.itemDescription
        photoImageNames = Self.makeImageURLs(from: item)
        location = item.location
        author = item.author
        category = item.category
        postedBy = Self.postedByText(from: item)
        dateText = Self.dateText(from: item)
        isFavorite = item.isFavorite
        isVisited = item.isVisited

        if let currentPhoto, let preservedIndex = photoImageNames.firstIndex(of: currentPhoto) {
            selectedPhotoIndex = preservedIndex
        } else if photoImageNames.isEmpty {
            selectedPhotoIndex = 0
        } else {
            selectedPhotoIndex = min(selectedPhotoIndex, photoImageNames.count - 1)
        }
    }

    private static func postedByText(from item: ArtItem) -> String {
        let uploadedByValue = item.uploadedBy?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return uploadedByValue?.isEmpty == false ? uploadedByValue! : "Unknown"
    }

    private static func dateText(from item: ArtItem) -> String? {
        guard let createdDate = item.createdDate else { return nil }
        return createdDate.formatted(date: .numeric, time: .omitted)
    }

    private static func makeImageURLs(from item: ArtItem) -> [String] {
        item.orderedImages
            .map(\.urlString)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // MARK: - Sample data

    static let sample = ArtObjectViewModel(
        name: "The Gliders",
        itemDescription: """
        Mural by Ana Markov originally painted in 2015.
        It explores themes of loneliness and social issues. ...
        """,
        photoImageNames: ["art", "bird", "cube"],
        location: "St. Petersburg",
        author: "Ana Markov",
        category: "Mural",
        postedBy: "Loxxych",
        dateText: "24.02.2025"
    )
}
