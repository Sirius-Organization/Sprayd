//
//  StartingAssembly.swift
//  Sprayd
//
//  Created by Codex on 08.04.2026.
//

import SwiftUI

struct StartingAssembly {
    func build(onGetStartedTapped: @escaping () -> Void) -> some View {
        let viewModel = StartingViewModel(onGetStarted: onGetStartedTapped)

        return StartingView(onGetStartedTapped: viewModel.didTapGetStarted)
    }
}
