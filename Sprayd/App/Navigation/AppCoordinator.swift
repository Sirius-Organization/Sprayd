//
//  AppCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {    
    // MARK: - Fields
    @Published var selectedTab: AppTab = .map
    
    let mapCoordinator: MapCoordinator
    let feedCoordinator: FeedCoordinator
    let profileCoordinator: ProfileCoordinator

    // MARK: - Lifecycle
    init(compositionRoot: CompositionRoot) {
        self.mapCoordinator = MapCoordinator(
            artItemsInBoxService: compositionRoot.artItemsInBoxService
        )
        self.feedCoordinator = FeedCoordinator(
            artItemsInBoxService: compositionRoot.artItemsInBoxService
        )
        self.profileCoordinator = ProfileCoordinator(
            authorizationService: compositionRoot.authorizationService,
            imageLoaderService: compositionRoot.imageLoaderService,
            userService: compositionRoot.userService,
            tokenStore: compositionRoot.sessionTokenStore,
            artAdditionRepository: compositionRoot.artAdditionRepository
        )
    }
    
    // MARK: - Navigation logic
    func selectTab(_ tab: AppTab) {
        selectedTab = tab
    }
}
