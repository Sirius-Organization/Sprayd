//
//  MapCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftData
import SwiftUI
internal import Combine

final class MapCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [MapRoute] = []
    private let modelContext: ModelContext

    // MARK: - Lifecycle
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Navigation logic
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    func makeRootView() -> some View {
        MainMapAssembly(
            modelContext: modelContext
        )
        .build()
    }
    
    @ViewBuilder
        func destination(for route: MapRoute) -> some View {
            // TODO: - Coordinate to designated route
        }
}
