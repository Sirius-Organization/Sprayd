//
//  OnboardingView.swift
//  Sprayd
//
//  Created by loxxy on 05.04.2026.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Constants
    private enum Const {
        static let animationDuration: CGFloat = 0.45
    }

    enum Step {
        case welcome
        case chooseAccount
    }

    enum Route: Hashable {
        case signIn
        case createAccount
    }

    // MARK: - Fields
    @State private var step: Step = .welcome
    @State private var path: [Route] = []

    let authorizationService: AuthorizationService
    var onFinished: () -> Void = {}

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()

            Group {
                switch step {
                case .welcome:
                    StartingView {
                        withAnimation(.easeInOut(duration: Const.animationDuration)) {
                            step = .chooseAccount
                        }
                    }
                    .transition(.opacity)

                case .chooseAccount:
                    NavigationStack(path: $path) {
                        ChooseAccountView(
                            onSignInTapped: {
                                path.append(.signIn)
                            },
                            onCreateAccountTapped: {
                                path.append(.createAccount)
                            },
                            onProceedWithoutAccountTapped: {
                                withAnimation {
                                    onFinished()
                                }
                            }
                        )
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .signIn:
                                SignInView(onContinueTapped: {
                                    // TODO: sign in action
                                })
                            case .createAccount:
                                CreateAccountView(
                                    authorizationService: authorizationService,
                                    onRegistrationSuccess: {
                                        withAnimation {
                                            onFinished()
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.opacity)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(authorizationService: try! AuthorizationService(sender: Sender()))
}
