//
//  AppCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
internal import Combine

final class AppCoordinator: ObservableObject {    
    // MARK: - Fields
    @Published var selectedTab: AppTab = .map
    
    let mapCoordinator: MapCoordinator
    let feedCoordinator: FeedCoordinator
    let profileCoordinator: ProfileCoordinator

    // MARK: - Lifecycle
    init(compositionRoot: CompositionRoot) {
        self.mapCoordinator = MapCoordinator(
            modelContext: compositionRoot.modelContext
        )
        self.feedCoordinator = FeedCoordinator()
        self.profileCoordinator = ProfileCoordinator()
    }
    
    // MARK: - Navigation logic
    func selectTab(_ tab: AppTab) {
        selectedTab = tab
    }
}
