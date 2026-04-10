//
//  AppCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
import SwiftData

struct AppCoordinatorView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var coordinator: AppCoordinator
    @State private var hasStartedInitialSync = false
    @State private var isSyncingArtItems = false
    private let modelContext: ModelContext

    init(compositionRoot: CompositionRoot) {
        self.modelContext = compositionRoot.modelContext
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
        .task {
            await syncArtItemsIfNeeded(force: false)
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }

            Task {
                await syncArtItemsIfNeeded(force: true)
            }
        }
    }

    @MainActor
    private func syncArtItemsIfNeeded(force: Bool) async {
        guard !AppTestingConfiguration.current.shouldDisableAutomaticSync else { return }
        guard force || !hasStartedInitialSync else { return }
        guard !isSyncingArtItems else { return }

        hasStartedInitialSync = true
        isSyncingArtItems = true
        defer { isSyncingArtItems = false }

        do {
            let service = ArtSyncService(modelContext: modelContext)
            try await service.syncArtItems()
        } catch {
            print("Automatic art sync error:", error)
        }
    }
}
