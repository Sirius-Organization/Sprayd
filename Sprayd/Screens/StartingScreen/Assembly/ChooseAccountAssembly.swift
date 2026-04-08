//
//  ChooseAccountAssembly.swift
//  Sprayd
//
//  Created by Codex on 08.04.2026.
//

import SwiftUI

struct ChooseAccountAssembly {
    func build(
        onSignInTapped: @escaping () -> Void,
        onCreateAccountTapped: @escaping () -> Void,
        onProceedWithoutAccountTapped: @escaping () -> Void
    ) -> some View {
        let viewModel = ChooseAccountViewModel(
            onSignInTapped: onSignInTapped,
            onCreateAccountTapped: onCreateAccountTapped,
            onProceedWithoutAccountTapped: onProceedWithoutAccountTapped
        )

        return ChooseAccountView(
            onSignInTapped: viewModel.didTapSignIn,
            onCreateAccountTapped: viewModel.didTapCreateAccount,
            onProceedWithoutAccountTapped: viewModel.didTapProceedWithoutAccount
        )
    }
}
