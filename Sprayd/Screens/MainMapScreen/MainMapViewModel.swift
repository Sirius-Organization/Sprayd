//
//  MainMapViewModel.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import MapKit
import SwiftData

@MainActor
@Observable
final class MainMapViewModel {
    var region: MKCoordinateRegion
    var items: [ArtItem]
    
    private let modelContext: ModelContext
    private let imageLoader: ImageLoaderService

    init(
        modelContext: ModelContext,
        imageLoader: ImageLoaderService,
        region: MKCoordinateRegion,
        items: [ArtItem]
    ) {
        self.modelContext = modelContext
        self.imageLoader = imageLoader
        self.region = region
        self.items = items
    }
    
    func imageData(for urlString: String) async -> Data? {
        await imageLoader.loadImageData(from: urlString)
    }
}
