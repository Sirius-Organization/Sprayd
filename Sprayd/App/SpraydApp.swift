//
//  SpraydApp.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct SpraydApp: App {
    private let compositionRoot: CompositionRoot

    init() {
        do {
            try Tips.configure()
        }
        catch {
            print("Error initializing TipKit \(error.localizedDescription)")
        }
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
