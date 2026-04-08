//
//  OnboardingView.swift
//  Sprayd
//
//  Created by loxxy on 05.04.2026.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var coordinator: OnboardingCoordinator

    init(
        authorizationService: AuthorizationService,
        onFinished: @escaping () -> Void = {}
    ) {
        _coordinator = StateObject(
            wrappedValue: OnboardingCoordinator(
                authorizationService: authorizationService,
                onFinished: onFinished
            )
        )
    }

    var body: some View {
        OnboardingCoordinatorView(coordinator: coordinator)
    }
}

// MARK: - Preview
#Preview {
    if let sender = try? Sender() {
        OnboardingView(authorizationService: AuthorizationService(sender: sender))
    } else {
        Text("Failed to initialize preview")
    }
}
