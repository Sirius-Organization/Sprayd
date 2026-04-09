//
//  CompositionRoot.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import SwiftData
import CoreLocation

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

    lazy var locationProvider: LocationProvider = LocationProvider(
        locationManager: CLLocationManager()
    )

    lazy var sender: Sender = Sender()
    lazy var artItemsInBoxService: ArtItemsInBoxService = {
        ArtItemsInBoxService(
            sender: sender,
            modelContext: modelContext
        )
    }()
    lazy var authorizationService: AuthorizationService = {
        AuthorizationService(
            sender: sender,
            tokenStore: sessionTokenStore
        )
    }()
    lazy var userService: UserService = {
        UserService(sender: sender)
    }()

    lazy var artAdditionService: ArtAdditionService = {
        ArtAdditionService(
            sender: sender,
            tokenStore: sessionTokenStore
        )
    }()

    lazy var artAdditionRepository: ArtAdditionRepository = {
        ArtAdditionRepository(
            service: artAdditionService,
            modelContext: modelContext
        )
    }()

    lazy var sessionTokenStore: SessionTokenStoring = {
        SessionTokenStore()
    }()
}
