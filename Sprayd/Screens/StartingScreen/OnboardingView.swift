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
        static let gradientRadius: CGFloat = 400
        static let animationDuration: CGFloat = 0.45
    }

    enum Step {
        case welcome
        case chooseAccount
    }

    // MARK: - Fields
    @State private var step: Step = .welcome

    var onFinished: () -> Void = {}

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    .gradientCenterColor,
                    .gradientEdgeColor
                ]),
                center: .center,
                startRadius: 0,
                endRadius: Const.gradientRadius
            )
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
                    ChooseAccountView(
                        onSignInTapped: {
                            // TODO: navigate to sign in
                        },
                        onCreateAccountTapped: {
                            // TODO: navigate to create account
                        },
                        onProceedWithoutAccountTapped: {
                            withAnimation {
                                onFinished()
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
