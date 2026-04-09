//
//  FeedCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import SwiftData
internal import Combine

@MainActor
final class FeedCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [FeedRoute] = []
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
                works: works(forAuthor: username)
            )
        case .userProfile(let username):
            UserProfileAssembly().build(
                username: username,
                posts: posts(forUser: username)
            )
        }
    }

    private func item(withID id: UUID) -> ArtItem? {
        let descriptor = FetchDescriptor<ArtItem>(
            predicate: #Predicate<ArtItem> { item in
                item.id == id
            }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func works(forAuthor author: String) -> [ArtItem] {
        let authorName = normalized(author)
        guard !authorName.isEmpty else { return [] }
        let items = (try? modelContext.fetch(FetchDescriptor<ArtItem>())) ?? []
        return items.filter { normalized($0.author) == authorName }
    }

    private func posts(forUser user: String) -> [ArtItem] {
        let username = normalized(user)
        guard !username.isEmpty else { return [] }
        let items = (try? modelContext.fetch(FetchDescriptor<ArtItem>())) ?? []
        return items.filter { normalized($0.uploadedBy ?? "") == username }
    }

    private func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
