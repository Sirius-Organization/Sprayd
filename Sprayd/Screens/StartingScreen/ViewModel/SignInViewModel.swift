//
//  SignInViewModel.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

@MainActor
@Observable
final class SignInViewModel {
    // MARK: - Fields
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    private let authorizationService: AuthorizationService
    private let onLoginSuccess: () -> Void
    private static let errorBannerDuration: TimeInterval = 3

    // MARK: - Init
    init(
        authorizationService: AuthorizationService,
        onLoginSuccess: @escaping () -> Void = {}
    ) {
        self.authorizationService = authorizationService
        self.onLoginSuccess = onLoginSuccess
    }

    // MARK: - Validation
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    // MARK: - Actions
    func login() {
        guard isFormValid, !isLoading else { return }
        isLoading = true

        Task {
            do {
                let response = try await authorizationService.login(
                    email: email,
                    password: password
                )
                UserDefaults.standard.set(response.token, forKey: "userToken")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                onLoginSuccess()
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
        Task {
            try? await Task.sleep(for: .seconds(Self.errorBannerDuration))
            errorMessage = nil
        }
    }
}
