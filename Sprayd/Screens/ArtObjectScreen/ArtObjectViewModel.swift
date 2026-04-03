//
//  ArtObjectViewModel.swift
//  Sprayd
//

import Foundation

@Observable
final class ArtObjectViewModel {
    struct PhotoItem: Identifiable {
        let index: Int
        let imageName: String

        var id: Int { index }
    }

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

    var photoItems: [PhotoItem] {
        photoImageNames.enumerated().map {
            PhotoItem(index: $0.offset, imageName: $0.element)
        }
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
