//
//  ArtAdditionViewModel.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
internal import Combine
import CoreLocation

final class ArtAdditionViewModel: ObservableObject {
    // MARK: - Fields
    @Published var addedPhotos: [ArtImage] = []
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedLocationName: String?
    @Published var isLocationPickerPresented: Bool = false
    @Published var selectedAuthor: Author?
    @Published var selectedCategory: Category?
    
    // MARK: - Logic
    
}
