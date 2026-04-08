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
  
    lazy var imageCacheService: ImageCacheService = {
        ImageCacheService()
    }()
   
    lazy var imageLoaderService: ImageLoaderService = {
        ImageLoaderService(imageCacheService: imageCacheService)
    }()

    lazy var sender: Sender = Sender()

    lazy var authorizationService: AuthorizationService = {
        AuthorizationService(sender: sender)
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
