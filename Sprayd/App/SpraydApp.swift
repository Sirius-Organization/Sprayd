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
    private let modelContainer: ModelContainer

    init() {
        do {
            try Tips.configure()
        } catch {
            print("Error initializing TipKit \(error.localizedDescription)")
        }
        AppTestingBootstrapper.applyRuntimeOverrides()
        self.modelContainer = AppTestingBootstrapper.makeModelContainer()
        self.compositionRoot = CompositionRoot(context: modelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(compositionRoot: compositionRoot)
                .tint(.accentRed)
        }
        .modelContainer(modelContainer)
    }
}
