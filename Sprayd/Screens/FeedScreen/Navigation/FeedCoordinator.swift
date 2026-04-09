//
//  FeedCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import Combine

@MainActor
final class FeedCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [FeedRoute] = []
    private let artItemsInBoxService: ArtItemsInBoxService

    init(artItemsInBoxService: ArtItemsInBoxService) {
        self.artItemsInBoxService = artItemsInBoxService
    }

    // MARK: - Navigation logic
    func openArtObject(_ item: ArtItem) {
        path.append(.artObject(item.id))
    }

    func openArtistProfile(username: String) {
        let normalizedUsername = normalized(username)
        guard !normalizedUsername.isEmpty else { return }
        path.append(.artistProfile(normalizedUsername))
    }

    func openUserProfile(username: String) {
        let normalizedUsername = normalized(username)
        guard !normalizedUsername.isEmpty, normalizedUsername != "Unknown" else { return }
        path.append(.userProfile(normalizedUsername))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    func makeRootView() -> some View {
        FeaturedView(
            onSelectItem: { [weak self] item in
                self?.openArtObject(item)
            }
        )
    }
    
    @ViewBuilder
    func destination(for route: FeedRoute) -> some View {
        switch route {
        case .artObject(let itemID):
            if let item = item(withID: itemID) {
                ArtObjectView(
                    item: item,
                    onAuthorTap: { [weak self] username in
                        self?.openArtistProfile(username: username)
                    },
                    onPostedByTap: { [weak self] username in
                        self?.openUserProfile(username: username)
                    }
                )
            } else {
                Text("Art object not found")
            }
        case .artistProfile(let username):
            ArtistProfileAssembly().build(
                username: username,
                works: artItemsInBoxService.items(forAuthor: username)
            )
        case .userProfile(let username):
            UserProfileAssembly().build(
                username: username,
                posts: artItemsInBoxService.items(forUploadedByUsername: username)
            )
        }
    }

    private func item(withID id: UUID) -> ArtItem? {
        artItemsInBoxService.item(withID: id)
    }

    private func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
