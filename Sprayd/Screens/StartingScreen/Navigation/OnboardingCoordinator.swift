//
//  OnboardingCoordinator.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftUI
internal import Combine

enum OnboardingStep {
    case welcome
    case chooseAccount
}

final class OnboardingCoordinator: ObservableObject {
    private enum Const {
        static let animationDuration: CGFloat = 0.45
    }

    // MARK: - Fields
    @Published var step: OnboardingStep = .welcome
    @Published var path: [OnboardingRoute] = []

    private let authorizationService: AuthorizationService
    private let onFinished: () -> Void

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        onFinished: @escaping () -> Void = {}
    ) {
        self.authorizationService = authorizationService
        self.onFinished = onFinished
    }

    // MARK: - Navigation logic
    func openChooseAccount() {
        withAnimation(.easeInOut(duration: Const.animationDuration)) {
            step = .chooseAccount
        }
    }

    func openSignIn() {
        path.append(.signIn)
    }

    func openCreateAccount() {
        path.append(.createAccount)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func finishOnboarding() {
        withAnimation(.easeInOut(duration: Const.animationDuration)) {
            onFinished()
        }
    }

    // MARK: - View building
    @ViewBuilder
    func makeWelcomeView() -> some View {
        StartingAssembly()
            .build(onGetStartedTapped: openChooseAccount)
    }

    @ViewBuilder
    func makeChooseAccountView() -> some View {
        ChooseAccountAssembly()
            .build(
                onSignInTapped: openSignIn,
                onCreateAccountTapped: openCreateAccount,
                onProceedWithoutAccountTapped: finishOnboarding
            )
    }

    @ViewBuilder
    func destination(for route: OnboardingRoute) -> some View {
        switch route {
        case .signIn:
            SignInAssembly(authorizationService: authorizationService)
                .build(onLoginSuccess: finishOnboarding)
        case .createAccount:
            CreateAccountAssembly(authorizationService: authorizationService)
                .build(onRegistrationSuccess: finishOnboarding)
        }
    }
}
