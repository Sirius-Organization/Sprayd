//
//  ProfileCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import Combine

final class ProfileCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [ProfileRoute] = []
    private let artAdditionRepository: ArtAdditionRepository
    private let authorizationService: AuthorizationService
    private let userService: UserService
    private let tokenStore: SessionTokenStoring

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        userService: UserService,
        tokenStore: SessionTokenStoring,
        artAdditionRepository: ArtAdditionRepository

    ) {
        self.authorizationService = authorizationService
        self.userService = userService
        self.tokenStore = tokenStore
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
        MyProfileAssembly(
            authorizationService: authorizationService,
            userService: userService,
            tokenStore: tokenStore)
        .build(
            onAddArt: { [weak self] in
                self?.openAddArt()
            }
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
