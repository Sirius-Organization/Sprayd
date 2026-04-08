//
//  CompositionRoot.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import SwiftData

@MainActor
final class CompositionRoot {
    let modelContext: ModelContext
    
    init(context: ModelContext) {
        self.modelContext = context
    }
    
    lazy var imageLoaderService: ImageLoaderService = {
        ImageLoaderService(modelContext: modelContext)
    }()

    lazy var sender: Sender = {
        do {
            return try Sender()
        } catch {
            fatalError("Failed to create Sender: \(error)")
        }
    }()

    lazy var artAdditionService: ArtAdditionService = {
        ArtAdditionService(sender: sender)
    }()

    lazy var artAdditionRepository: ArtAdditionRepository = {
        ArtAdditionRepository(
            service: artAdditionService,
            modelContext: modelContext
        )
    }()
}
