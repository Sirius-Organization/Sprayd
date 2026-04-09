//
//  CreateAccountAssembly.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftUI

struct CreateAccountAssembly {
    let authorizationService: AuthorizationService
    let tokenStore: SessionTokenStoring

    func build(onRegistrationSuccess: @escaping () -> Void) -> some View {
        CreateAccountScreen(
            viewModel: CreateAccountViewModel(
                authorizationService: authorizationService,
                tokenStore: tokenStore,
                onRegistrationSuccess: onRegistrationSuccess
            )
        )
    }
}

private struct CreateAccountScreen: View {
    @State private var viewModel: CreateAccountViewModel

    init(viewModel: CreateAccountViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        CreateAccountView(
            username: $viewModel.username,
            email: $viewModel.email,
            password: $viewModel.password,
            repeatedPassword: $viewModel.repeatedPassword,
            isErrorAlertPresented: $viewModel.isErrorAlertPresented,
            usernameValidationState: viewModel.validationState(
                for: viewModel.username,
                isValid: viewModel.isUsernameValid
            ),
            emailValidationState: viewModel.validationState(
                for: viewModel.email,
                isValid: viewModel.isEmailValid
            ),
            repeatPasswordValidationState: viewModel.validationState(
                for: viewModel.repeatedPassword,
                isValid: viewModel.isRepeatPasswordMatching
            ),
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            isFormValid: viewModel.isFormValid,
            onContinueTapped: viewModel.register,
            onErrorDismissed: viewModel.dismissError
        )
    }
}
