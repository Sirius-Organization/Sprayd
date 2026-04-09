//
//  MyProfileAssembly.swift
//  Sprayd
//
//  Created by loxxy on 09.04.2026.
//

import SwiftUI

struct MyProfileAssembly {
    let authorizationService: AuthorizationService
    let tokenStore: SessionTokenStoring

    func build(onAddArt: @escaping () -> Void) -> some View {
        MyProfileView(
            onAddArt: onAddArt,
            viewModel: MyProfileViewModel(
                authorizationService: authorizationService,
                tokenStore: tokenStore
            )
        )
    }
}
