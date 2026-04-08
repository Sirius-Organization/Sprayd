//
//  SignInView.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI

struct SignInView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28

        static let titleText = "Sign in"
        static let emailTitle = "Email"
        static let passwordTitle = "Password"
        static let emailPlaceholder = "Enter email*"
        static let passwordPlaceholder = "Enter password*"
        static let continueText = "Continue"
    }

    // MARK: - Fields
    @Binding var email: String
    @Binding var password: String

    let isLoading: Bool
    let errorMessage: String?
    let isFormValid: Bool
    let onContinueTapped: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                Spacer()
                    .frame(height: Metrics.tenTimesModule)

                Text(Const.titleText)
                    .font(.ClimateCrisis52)
                    .foregroundStyle(Color.black)

                AuthInputField(
                    title: Const.emailTitle,
                    placeholder: Const.emailPlaceholder,
                    text: $email,
                    textContentType: .emailAddress
                )

                AuthInputField(
                    title: Const.passwordTitle,
                    placeholder: Const.passwordPlaceholder,
                    text: $password,
                    isSecure: true,
                    isPasswordToggleable: true,
                    textContentType: .oneTimeCode
                )

                continueButton
                    .padding(.top, Metrics.doubleModule)

                Spacer()
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(maxWidth: .infinity, alignment: .leading)

            if let errorMessage {
                VStack {
                    errorBanner(message: errorMessage)
                        .padding(.horizontal, Metrics.tripleModule)
                        .padding(.top, Metrics.module)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: errorMessage)
    }

    // MARK: - Subviews
    private var continueButton: some View {
        Button(action: onContinueTapped) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(Const.continueText)
                        .font(.InstrumentMedium20)
                        .foregroundStyle(Color.white)
                }

                Spacer()

                if !isLoading {
                    Icons.chevronRight
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(isFormValid ? Color.black : Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Metrics.tripleModule)
        .disabled(!isFormValid || isLoading)
    }

    private func errorBanner(message: String) -> some View {
        Text(message)
            .font(.InstrumentMedium16)
            .foregroundStyle(.white)
            .padding(Metrics.doubleModule)
            .frame(maxWidth: .infinity)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SignInPreview()
}

private struct SignInPreview: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        SignInView(
            email: $email,
            password: $password,
            isLoading: false,
            errorMessage: nil,
            isFormValid: false,
            onContinueTapped: {}
        )
    }
}
