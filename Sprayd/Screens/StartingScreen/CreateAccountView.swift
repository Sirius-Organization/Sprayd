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
        static let errorBannerDuration: TimeInterval = 3

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
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userId") private var userId: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""

    let authorizationService: AuthorizationService
    let onRegistrationSuccess: () -> Void

    // MARK: - Validation

    private static let usernameRegex = /^[A-Za-z0-9_]{3,20}$/
    private static let emailRegex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/

    private var isUsernameValid: Bool {
        (try? Self.usernameRegex.wholeMatch(in: username)) != nil
    }

    private var isEmailValid: Bool {
        (try? Self.emailRegex.wholeMatch(in: email)) != nil
    }

    private var isPasswordValid: Bool {
        guard password.count >= 8 else { return false }
        var classes = 0
        if password.contains(where: { $0.isUppercase }) { classes += 1 }
        if password.contains(where: { $0.isLowercase }) { classes += 1 }
        if password.contains(where: { $0.isNumber }) { classes += 1 }
        if password.contains(where: { !$0.isLetter && !$0.isNumber }) { classes += 1 }
        return classes >= 2
    }

    private var isRepeatPasswordMatching: Bool {
        repeatedPassword == password
    }

    private var isRepeatPasswordValid: Bool {
        !repeatedPassword.isEmpty && isRepeatPasswordMatching
    }

    private var isFormValid: Bool {
        isUsernameValid && isEmailValid && !password.isEmpty && isRepeatPasswordValid
    }

    private func validationState(for text: String, isValid: Bool) -> ValidationState {
        guard !text.isEmpty else { return .none }
        return isValid ? .valid : .invalid
    }

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
                    text: $username,
                    validationState: validationState(for: username, isValid: isUsernameValid),
                    textContentType: .username
                )

                AuthInputField(
                    title: Const.emailTitle,
                    placeholder: Const.emailPlaceholder,
                    text: $email,
                    validationState: validationState(for: email, isValid: isEmailValid),
                    textContentType: .emailAddress
                )

                AuthInputField(
                    title: Const.passwordTitle,
                    placeholder: Const.passwordPlaceholder,
                    text: $password,
                    isSecure: true,
                    isPasswordToggleable: true,
                    validationState: .none,
                    textContentType: .oneTimeCode
                )

                AuthInputField(
                    title: Const.repeatPasswordTitle,
                    placeholder: Const.repeatPasswordPlaceholder,
                    text: $repeatedPassword,
                    isSecure: true,
                    isPasswordToggleable: true,
                    validationState: validationState(for: repeatedPassword, isValid: isRepeatPasswordMatching),
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
    }

    // MARK: - Subviews
    private var continueButton: some View {
        Button(action: performRegistration) {
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

    // MARK: - Actions
    private func performRegistration() {
        guard isFormValid, !isLoading else { return }
        isLoading = true

        Task {
            do {
                let response = try await authorizationService.register(
                    email: email,
                    password: password
                )
                userId = response.id?.uuidString ?? ""
                userEmail = response.email
                isLoggedIn = true
                onRegistrationSuccess()
            } catch let error as APIErrorResponse {
                showError(error.reason)
            } catch {
                showError("Something went wrong. Please try again.")
            }
            isLoading = false
        }
    }

    private func showError(_ message: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            errorMessage = message
        }
        Task {
            try? await Task.sleep(for: .seconds(Const.errorBannerDuration))
            withAnimation(.easeInOut(duration: 0.3)) {
                errorMessage = nil
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CreateAccountView(
        authorizationService: try! AuthorizationService(sender: Sender()),
        onRegistrationSuccess: {}
    )
}
