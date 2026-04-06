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

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                AppCoordinatorView(compositionRoot: compositionRoot)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            } else {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: hasCompletedOnboarding)
    }
}
