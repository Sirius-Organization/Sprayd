//
//  ArtObjectViewModel.swift
//  Sprayd
//

import Foundation
import SwiftData

@Observable
final class ArtObjectViewModel {
    // MARK: - Data fields
    let name: String
    let itemDescription: String
    let photoImageNames: [String]
    let location: String
    let author: String
    let category: String
    let postedBy: String
    let dateText: String

    // MARK: - UI state
    var selectedPhotoIndex: Int = 0
    var isPhotoPreviewPresented: Bool = false
    var isLiked: Bool = false
    var likesCount: Int = 0
    var isVisited: Bool = false

    // MARK: - Init
    init(
        name: String,
        itemDescription: String,
        photoImageNames: [String],
        location: String,
        author: String,
        category: String,
        postedBy: String,
        dateText: String
    ) {
        self.name = name
        self.itemDescription = itemDescription
        self.photoImageNames = photoImageNames
        self.location = location
        self.author = author
        self.category = category
        self.postedBy = postedBy
        self.dateText = dateText
    }

    convenience init(item: ArtItem) {
        let uploadedByValue = item.uploadedBy?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let imageURLs = item.images
            .map(\.urlString)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        self.init(
            name: item.name,
            itemDescription: item.itemDescription,
            photoImageNames: imageURLs,
            location: item.location,
            author: item.author,
            category: item.category,
            postedBy: (uploadedByValue?.isEmpty == false ? uploadedByValue! : "Unknown"),
            dateText: item.createdAt.formatted(date: .numeric, time: .omitted)
        )

        likesCount = item.likesCount
    }

    // MARK: - Actions

    func toggleLike() {
        isLiked.toggle()
        likesCount += isLiked ? 1 : -1
    }

    func toggleVisited() {
        isVisited.toggle()
    }

    func openPhotoPreview(at index: Int) {
        selectedPhotoIndex = index
        isPhotoPreviewPresented = true
    }

    // MARK: - Sample data

    static let sample = ArtObjectViewModel(
        name: "The Gliders",
        itemDescription: "Mural by Ana Markov originally painted in 2015. It explores themes of loneliness and social issues. ...",
        photoImageNames: ["art", "bird", "cube"],
        location: "St. Petersburg",
        author: "Ana Markov",
        category: "Mural",
        postedBy: "Loxxych",
        dateText: "24.02.2025"
    )
}
