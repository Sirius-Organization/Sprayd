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
    private struct Constants {
        static let fatalError = "Failed to create ModelContainer: "
    }
    
    private let sharedModelContainer: ModelContainer
    private let compositionRoot: CompositionRoot

    init() {
        do {
            let modelContainer = try ModelContainer(
                for: ArtItem.self,
                ArtImage.self
            )
            self.sharedModelContainer = modelContainer
            self.compositionRoot = CompositionRoot(context: modelContainer.mainContext)
        } catch {
            fatalError(Constants.fatalError + "\(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(compositionRoot: compositionRoot)
                .tint(.accentRed)
        }
        .modelContainer(sharedModelContainer)
    }
}
