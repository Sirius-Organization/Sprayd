//
//  ContentView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    private let compositionRoot: CompositionRoot
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }

    var body: some View {
        ZStack {
            if hasCompletedOnboarding || isLoggedIn {
                AppCoordinatorView(compositionRoot: compositionRoot)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            } else {
                OnboardingView(
                    authorizationService: compositionRoot.authorizationService,
                    tokenStore: compositionRoot.sessionTokenStore
                ) {
                    withAnimation(Motion.standard) {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .animation(Motion.standard, value: hasCompletedOnboarding)
        .imageLoaderService(compositionRoot.imageLoaderService)
        .task {
            compositionRoot.locationProvider.requestAuthorize()
        }
    }
}
