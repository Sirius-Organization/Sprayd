//
//  AppCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
                    MapCoordinatorView(coordinator: coordinator.mapCoordinator)
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }
                        .tag(AppTab.map)
                    
                    FeedCoordinatorView(coordinator: coordinator.feedCoordinator)
                        .tabItem {
                            Label("Featured", systemImage: "star")
                        }
                        .tag(AppTab.feed)
                    
                    ProfileCoordinatorView(coordinator: coordinator.profileCoordinator)
                        .tabItem {
                            Label("Account", systemImage: "person.crop.circle.fill")
                        }
                        .tag(AppTab.profile)
                }
    }
}
