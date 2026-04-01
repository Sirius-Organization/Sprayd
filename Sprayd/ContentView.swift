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
    @Query private var items: [Item]

    var body: some View {
        TabView {
            
            Tab("Map", systemImage: "map") {
                Color.green.ignoresSafeArea()
            }
            
            Tab("Featured", systemImage: "star") {
                EmptyView()
            }
            
            
            Tab("Account", systemImage: "person.crop.circle.fill") {
                    EmptyView()
            }
            
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
