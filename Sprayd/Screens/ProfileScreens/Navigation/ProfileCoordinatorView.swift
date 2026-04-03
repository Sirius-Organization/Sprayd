//
//  ProfileCoordinatorView.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct ProfileCoordinatorView: View {
    @ObservedObject var coordinator: ProfileCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: ProfileRoute.self) { route in
                    coordinator.destination(for: route)
                }
        }
    }
}
