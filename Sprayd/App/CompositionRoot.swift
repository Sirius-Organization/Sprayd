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
}
