//
//  CreateAccountView.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI

struct CreateAccountView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28

        static let titleText = "Create\naccount"
        static let usernameTitle = "Username"
        static let emailTitle = "Email"
        static let passwordTitle = "Password"
        static let repeatPasswordTitle = "Password"
        static let usernamePlaceholder = "Enter username*"
        static let emailPlaceholder = "Enter email*"
        static let passwordPlaceholder = "Enter password*"
        static let repeatPasswordPlaceholder = "Repeat password*"
        static let continueText = "Continue"
    }

    // MARK: - Fields
    @Bindable var viewModel: CreateAccountViewModel

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                Text(Const.titleText)
                    .font(.ClimateCrisis52)
                    .foregroundStyle(Color.black)

                AuthInputField(
                    title: Const.usernameTitle,
                    placeholder: Const.usernamePlaceholder,
                    text: $viewModel.username,
                    validationState: viewModel.validationState(
                        for: viewModel.username,
                        isValid: viewModel.isUsernameValid
                    ),
                    textContentType: .username
                )

                AuthInputField(
                    title: Const.emailTitle,
                    placeholder: Const.emailPlaceholder,
                    text: $viewModel.email,
                    validationState: viewModel.validationState(
                        for: viewModel.email,
                        isValid: viewModel.isEmailValid
                    ),
                    textContentType: .emailAddress
                )

                AuthInputField(
                    title: Const.passwordTitle,
                    placeholder: Const.passwordPlaceholder,
                    text: $viewModel.password,
                    isSecure: true,
                    isPasswordToggleable: true,
                    validationState: .none,
                    textContentType: .oneTimeCode
                )

                AuthInputField(
                    title: Const.repeatPasswordTitle,
                    placeholder: Const.repeatPasswordPlaceholder,
                    text: $viewModel.repeatedPassword,
                    isSecure: true,
                    isPasswordToggleable: true,
                    validationState: viewModel.validationState(
                        for: viewModel.repeatedPassword,
                        isValid: viewModel.isRepeatPasswordMatching
                    ),
                    textContentType: .oneTimeCode
                )

                continueButton
                    .padding(.top, Metrics.doubleModule)

                Spacer()
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(maxWidth: .infinity, alignment: .leading)

            if let errorMessage = viewModel.errorMessage {
                VStack {
                    errorBanner(message: errorMessage)
                        .padding(.horizontal, Metrics.tripleModule)
                        .padding(.top, Metrics.module)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
    }

    // MARK: - Subviews
    private var continueButton: some View {
        Button(action: viewModel.register) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(Const.continueText)
                        .font(.InstrumentMedium20)
                        .foregroundStyle(Color.white)
                }

                Spacer()

                if !viewModel.isLoading {
                    Icons.chevronRight
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(viewModel.isFormValid ? Color.black : Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Metrics.tripleModule)
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
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

// MARK: - Preview
#Preview {
    if let sender = try? Sender() {
        CreateAccountView(
            viewModel: CreateAccountViewModel(
                authorizationService: AuthorizationService(sender: sender)
            )
        )
    } else {
        Text("Failed to initialize preview")
    }
}