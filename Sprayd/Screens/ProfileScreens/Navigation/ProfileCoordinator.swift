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

    private let authorizationService: AuthorizationService
    private let tokenStore: SessionTokenStoring

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        tokenStore: SessionTokenStoring
    ) {
        self.authorizationService = authorizationService
        self.tokenStore = tokenStore
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
            tokenStore: tokenStore
        )
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
                viewModel: ArtAdditionViewModel()
            )
        }
    }
}
