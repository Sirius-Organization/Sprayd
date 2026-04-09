//
//  SignInAssembly.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftUI

struct SignInAssembly {
    let authorizationService: AuthorizationService
    let tokenStore: SessionTokenStoring

    func build(onLoginSuccess: @escaping () -> Void) -> some View {
        SignInScreen(
            viewModel: SignInViewModel(
                authorizationService: authorizationService,
                tokenStore: tokenStore,
                onLoginSuccess: onLoginSuccess
            )
        )
    }
}

private struct SignInScreen: View {
    @State private var viewModel: SignInViewModel

    init(viewModel: SignInViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        SignInView(
            email: $viewModel.email,
            password: $viewModel.password,
            isErrorAlertPresented: $viewModel.isErrorAlertPresented,
            isLoading: viewModel.isLoading,
            errorMessage: viewModel.errorMessage,
            isFormValid: viewModel.isFormValid,
            onContinueTapped: viewModel.login,
            onErrorDismissed: viewModel.dismissError
        )
    }
}
