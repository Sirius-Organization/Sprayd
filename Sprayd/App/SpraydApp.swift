//
//  SpraydApp.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

@main
struct SpraydApp: App {
    private let compositionRoot: CompositionRoot

    init() {
        self.compositionRoot = CompositionRoot(context: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(compositionRoot: compositionRoot)
                .tint(.accentRed)
        }
        .modelContainer(sharedModelContainer)
    }
}
