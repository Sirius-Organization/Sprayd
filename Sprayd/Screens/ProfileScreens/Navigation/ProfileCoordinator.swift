//
//  ProfileCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
internal import Combine

final class ProfileCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [ProfileRoute] = []
    private let artAdditionRepository: ArtAdditionRepository
    private let authorizationService: AuthorizationService

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        artAdditionRepository: ArtAdditionRepository
    ) {
        self.authorizationService = authorizationService
        self.artAdditionRepository = artAdditionRepository
    }
    // MARK: - Navigation logic
    func openAddArt() {
        path.append(.addArt)
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
        MyProfileView(
            onAddArt: { [weak self] in
                self?.openAddArt()
            },
            viewModel: MyProfileViewModel(authorizationService: authorizationService)
        )
    }
    
    @ViewBuilder
    func destination(for route: ProfileRoute) -> some View {
        switch (route) {
        case .addArt:
            ArtAdditionView(
                onBackButtonTapped: { [weak self] in
                    self?.pop()},
                viewModel: ArtAdditionViewModel(
                    repository: artAdditionRepository
                )
            )
        }
    }
}
