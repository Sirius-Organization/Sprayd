//
//  MapCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct MapCoordinatorView: View {
    @ObservedObject var coordinator: MapCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: MapRoute.self) { route in
                    coordinator.destination(for: route)
                }
        }
    }
}
