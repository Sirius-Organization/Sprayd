//
//  AppCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    init(compositionRoot: CompositionRoot) {
        _coordinator = StateObject(
            wrappedValue: AppCoordinator(compositionRoot: compositionRoot)
        )
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            MapCoordinatorView(coordinator: coordinator.mapCoordinator)
                .tabItem {
                    Icons.map
                }
                .tag(AppTab.map)
            
            FeedCoordinatorView(coordinator: coordinator.feedCoordinator)
                .tabItem {
                    Icons.home
                }
                .tag(AppTab.feed)
            
            ProfileCoordinatorView(coordinator: coordinator.profileCoordinator)
                .tabItem {
                    Icons.profileIcon
                }
                .tag(AppTab.profile)
        }
    }
}
