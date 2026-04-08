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
        tokenStore: SessionTokenStoring,
        onFinished: @escaping () -> Void = {}
    ) {
        _coordinator = StateObject(
            wrappedValue: OnboardingCoordinator(
                authorizationService: authorizationService,
                tokenStore: tokenStore,
                onFinished: onFinished
            )
        )
    }

    var body: some View {
        OnboardingCoordinatorView(coordinator: coordinator)
    }
}
