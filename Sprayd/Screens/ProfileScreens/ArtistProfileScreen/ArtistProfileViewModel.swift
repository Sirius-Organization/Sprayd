//
//  ArtistProfileViewModel.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
internal import Combine

final class ArtistProfileViewModel: ObservableObject {

    // MARK: - Fields
    @Published var username: String
    @Published var bio: String
    @Published var works: [ArtItem]
    
    // MARK: - Lifecycle
    init(
        username: String = "Username",
        bio: String = "Description",
        works: [ArtItem] = [],
    ) {
        self.username = username
        self.bio = bio
        self.works = works
    }
    
    // MARK: - Logic
}
