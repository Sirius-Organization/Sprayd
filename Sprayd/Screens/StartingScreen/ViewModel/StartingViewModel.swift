//
//  StartingViewModel.swift
//  Sprayd
//
//  Created by Codex on 08.04.2026.
//

import Foundation

@MainActor
final class StartingViewModel {
    private let onGetStarted: () -> Void

    init(onGetStarted: @escaping () -> Void) {
        self.onGetStarted = onGetStarted
    }

    func didTapGetStarted() {
        onGetStarted()
    }
}
