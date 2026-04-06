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
            viewModel: MyProfileViewModel()
        )
    }
    
    @ViewBuilder
    func destination(for route: ProfileRoute) -> some View {
        switch (route) {
        case .addArt:
            ArtAdditionView(onBackButtonTapped: { [weak self] in
                self?.pop()})
        }
    }
}
