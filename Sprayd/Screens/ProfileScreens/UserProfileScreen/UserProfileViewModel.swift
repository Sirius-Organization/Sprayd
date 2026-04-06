//
//  UserProfileViewModel.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
internal import Combine

final class UserProfileViewModel: ObservableObject {

    // MARK: - Fields
    @Published var username: String
    @Published var bio: String
    @Published var posts: [ArtItem]
    
    // MARK: - Lifecycle
    init(
        username: String = "Username",
        bio: String = "Description",
        posts: [ArtItem] = [],
    ) {
        self.username = username
        self.bio = bio
        self.posts = posts
    }
    
    // MARK: - Logic
}
