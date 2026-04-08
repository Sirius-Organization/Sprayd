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

    init(
        modelContext: ModelContext,
        region: MKCoordinateRegion,
        items: [ArtItem]
    ) {
        self.modelContext = modelContext
        self.region = region
        self.items = items
    }
}
