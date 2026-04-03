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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accentRed)
        }
        .modelContainer(for: [
            ArtItem.self,
            ArtImage.self
        ])
    }
}
