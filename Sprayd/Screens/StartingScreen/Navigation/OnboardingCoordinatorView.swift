//
//  OnboardingCoordinatorView.swift
//  Sprayd
//
//  Created by Codex on 08.04.2026.
//

import SwiftUI

struct OnboardingCoordinatorView: View {
    @ObservedObject var coordinator: OnboardingCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                switch coordinator.step {
                case .welcome:
                    coordinator.makeWelcomeView()
                        .transition(.opacity)
                case .chooseAccount:
                    coordinator.makeChooseAccountView()
                        .transition(.opacity)
                }
            }
            .navigationDestination(for: OnboardingRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
