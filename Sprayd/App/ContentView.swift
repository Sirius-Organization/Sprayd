//
//  ContentView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    private let compositionRoot: CompositionRoot

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }

    var body: some View {
        TabView {
            MainMapAssembly(
                modelContext: compositionRoot.modelContext,
                imageLoader: compositionRoot.imageLoaderService
            )
            .build()
            .tabItem {
                Label("Map", systemImage: "map")
            }

            FeaturedView()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }

            MyProfileView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
