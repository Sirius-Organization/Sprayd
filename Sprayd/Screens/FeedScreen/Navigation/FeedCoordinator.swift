//
//  FeedCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI
internal import Combine

final class FeedCoordinator: ObservableObject {
    // MARK: - Fields
    @Published var path: [FeedRoute] = []
    
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
        FeaturedView()
    }
    
    @ViewBuilder
        func destination(for route: FeedRoute) -> some View {
            // TODO: - Coordinate to designated route
        }
}
