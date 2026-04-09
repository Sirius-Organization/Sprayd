//
//  CreateAccountViewModel.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

@MainActor
@Observable
final class CreateAccountViewModel {

    // MARK: - Fields
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var repeatedPassword: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isErrorAlertPresented: Bool = false

    private let authorizationService: AuthorizationService
    private let tokenStore: SessionTokenStoring
    private let onRegistrationSuccess: () -> Void

    // MARK: - Init
    init(
        authorizationService: AuthorizationService,
        tokenStore: SessionTokenStoring,
        onRegistrationSuccess: @escaping () -> Void = {}
    ) {
        self.authorizationService = authorizationService
        self.tokenStore = tokenStore
        self.onRegistrationSuccess = onRegistrationSuccess
    }

    // MARK: - Validation

    private static let usernameRegex = /^[A-Za-z0-9_]{3,20}$/
    private static let emailRegex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/

    var isUsernameValid: Bool {
        (try? Self.usernameRegex.wholeMatch(in: username)) != nil
    }

    var isEmailValid: Bool {
        (try? Self.emailRegex.wholeMatch(in: email)) != nil
    }

    var isPasswordValid: Bool {
        guard password.count >= 8 else { return false }
        var classes = 0
        if password.contains(where: { $0.isUppercase }) { classes += 1 }
        if password.contains(where: { $0.isLowercase }) { classes += 1 }
        if password.contains(where: { $0.isNumber }) { classes += 1 }
        if password.contains(where: { !$0.isLetter && !$0.isNumber }) { classes += 1 }
        return classes >= 2
    }

    var isRepeatPasswordMatching: Bool {
        repeatedPassword == password
    }

    var isFormValid: Bool {
        isUsernameValid && isEmailValid && isPasswordValid && !repeatedPassword.isEmpty && isRepeatPasswordMatching
    }

    func validationState(for text: String, isValid: Bool) -> ValidationState {
        guard !text.isEmpty else { return .none }
        return isValid ? .valid : .invalid
    }

    var passwordValidationState: ValidationState {
        validationState(for: password, isValid: isPasswordValid)
    }

    var usernameValidationMessage: String? {
        guard !username.isEmpty, !isUsernameValid else { return nil }
        return "Username must be 3-20 characters and use only letters, numbers, or _"
    }

    var emailValidationMessage: String? {
        guard !email.isEmpty, !isEmailValid else { return nil }
        return "Please enter a valid email address"
    }

    var passwordValidationMessage: String? {
        guard !password.isEmpty else { return nil }
        guard password.count >= 8 else {
            return "Password must consist of at least 8+ symbols"
        }

        guard isPasswordValid else {
            return "Password must include at least 2 character types"
        }

        return nil
    }

    var repeatPasswordValidationMessage: String? {
        guard !repeatedPassword.isEmpty, !isRepeatPasswordMatching else { return nil }
        return "Passwords do not match"
    }

    // MARK: - Actions

    func register() {
        guard isFormValid, !isLoading else { return }
        isLoading = true

        Task {
            do {
                let registerResponse = try await authorizationService.register(
                    email: email,
                    password: password
                )
                UserDefaults.standard.set(registerResponse.id?.uuidString ?? "", forKey: "userId")
                UserDefaults.standard.set(registerResponse.email, forKey: "userEmail")

                let loginResponse = try await authorizationService.login(
                    email: email,
                    password: password
                )
                guard tokenStore.save(token: loginResponse.token) else {
                    showError("Failed to save your session securely. Please try again.")
                    isLoading = false
                    return
                }
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                onRegistrationSuccess()
            } catch let error as APIErrorResponse {
                showError(error.errorMessage)
            } catch {
                showError("Something went wrong. Please try again.")
            }
            isLoading = false
        }
    }

    private func showError(_ message: String) {
        errorMessage = message
        isErrorAlertPresented = true
    }

    func dismissError() {
        errorMessage = nil
        isErrorAlertPresented = false
    }
}
