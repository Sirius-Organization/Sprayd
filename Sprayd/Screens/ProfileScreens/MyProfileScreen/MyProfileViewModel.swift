//
//  MyProfileViewModel.swift
//  Sprayd
//
//  Created by loxxy on 04.04.2026.
//

import SwiftUI
internal import Combine

final class MyProfileViewModel: ObservableObject {
    
    enum Option: String {
        case posted = "Posted"
        case visited = "Visited"
    }
    
    // MARK: - Fields
    @Published var selectedOption: Option
    @Published var username: String
    @Published var bio: String
    @Published var posts: [ArtItem]
    @Published var visited: [ArtItem]
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var selectedOptionTitle: String {
        selectedOption.rawValue
    }
    
    var shouldDisplayAddButton: Bool {
        selectedOption == .posted
    }
    
    var displayedItems: [ArtItem]? {
        selectedOption == .posted ? posts : visited
    }
    
    // MARK: - Lifecycle
    init(
        selectedOption: Option = .posted,
        username: String = "Username",
        bio: String = "Description",
        posts: [ArtItem] = [ArtItem(name: "ArtWork1", author: "Author"), ArtItem(name: "ArtWork2", author: "Author")],
        visited: [ArtItem] = [ArtItem(name: "ArtWork3", author: "Author")],
    ) {
        self.selectedOption = selectedOption
        self.username = username
        self.bio = bio
        self.posts = posts
        self.visited = visited
    }
    
    // MARK: - Logic
    func selectOption(_ option: Option) {
        selectedOption = option
    }
}
