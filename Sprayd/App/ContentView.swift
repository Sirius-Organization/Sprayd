//
//  ContentView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            FeaturedView()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }

            ProfileView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
