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
                    Image("mapIcon")
                        .renderingMode(.template)
                        .foregroundColor(.accentRed)
                }
                .tag(AppTab.map)
            
            FeedCoordinatorView(coordinator: coordinator.feedCoordinator)
                .tabItem {
                    Image("homeIcon")
                        .renderingMode(.template)
                        .foregroundColor(.accentRed)
                }
                .tag(AppTab.feed)
            
            ProfileCoordinatorView(coordinator: coordinator.profileCoordinator)
                .tabItem {
                    Image("profileIcon")
                        .renderingMode(.template)
                        .foregroundColor(.accentRed)
                }
                .tag(AppTab.profile)
        }
    }
}
