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
    var isErrorAlertPresented: Bool = false

    private let authorizationService: AuthorizationService
    private let tokenStore: SessionTokenStoring
    private let onLoginSuccess: () -> Void

    // MARK: - Init
    init(
        authorizationService: AuthorizationService,
        tokenStore: SessionTokenStoring,
        onLoginSuccess: @escaping () -> Void = {}
    ) {
        self.authorizationService = authorizationService
        self.tokenStore = tokenStore
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
                guard tokenStore.save(token: response.token) else {
                    showError("Failed to save your session securely. Please try again.")
                    isLoading = false
                    return
                }
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
        isErrorAlertPresented = true
    }

    func dismissError() {
        errorMessage = nil
        isErrorAlertPresented = false
    }
}
