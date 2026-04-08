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
    @Published var availableAuthors: [Author] = [
        Author(name: "Ana Markov"),
        Author(name: "Mira Chen"),
        Author(name: "Theo Ivanov"),
        Author(name: "Lina Petrova"),
        Author(name: "Noah Kim"),
        Author(name: "Sofia Belov")
    ]
    @Published var availableCategories: [Category] = [
        Category(name: "Mural"),
        Category(name: "Graffiti"),
        Category(name: "Stencil"),
        Category(name: "Installation"),
        Category(name: "Sticker art"),
        Category(name: "Poster")
    ]
    
    @Published var addedPhotos: [ArtImage] = []
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedLocationName: String?
    @Published var isLocationPickerPresented: Bool = false
    @Published var isAuthorPickerPresented: Bool = false
    @Published var isCategoryPickerPresented: Bool = false
    @Published var selectedAuthor: Author?
    @Published var selectedCategory: Category?
    
    // MARK: - Logic
    
}
