//
//  SwiftData.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftData

private let artSchema = Schema([
    Author.self,
    ArtItem.self,
    ArtImage.self
])

let sharedModelContainer: ModelContainer = {
    let configuration = ModelConfiguration(schema: artSchema)

    do {
        return try ModelContainer(
            for: artSchema,
            configurations: [configuration]
        )
    } catch {
        fatalError("Failed to create model container: \(error)")
    }
}()
