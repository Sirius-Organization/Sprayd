//
//  ContentView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            MainMapAssembly(modelContext: modelContext).makeView()
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

#Preview {
    ContentView()
        .modelContainer(for: [
            ArtItem.self,
            ArtImage.self
        ], inMemory: true)
}
