//
//  ArtAdditionViewModel.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
internal import Combine
import CoreLocation

@MainActor
final class ArtAdditionViewModel: ObservableObject {
    // MARK: - Fields
    @Published var availableAuthors: [Author] = []
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
    @Published var selectedAuthor: Author?
    @Published var selectedCategory: Category?
    @Published var isLoading: Bool = false
    @Published var isCreateButtonDisabled: Bool = false
    @Published var errorMessage: String?
    @Published var isErrorAlertPresented: Bool = false
    @Published var didCreateArtItem: Bool = false

    private let repository: ArtAdditionRepository
    private var didLoadInitialData = false
    
    init(repository: ArtAdditionRepository) {
        self.repository = repository
        self.selectedCategory = availableCategories.first
    }

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCoordinate != nil &&
        selectedLocationName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false &&
        selectedAuthor != nil &&
        selectedCategory != nil &&
        !isCreateButtonDisabled
    }

    func loadInitialDataIfNeeded() async {
        guard !didLoadInitialData else { return }
        didLoadInitialData = true
        await loadAuthors()
    }

    func loadAuthors() async {
        isLoading = true
        defer { isLoading = false }

        do {
            availableAuthors = try await repository.syncArtists()
            if selectedAuthor == nil {
                selectedAuthor = availableAuthors.first
            }
        } catch {
            do {
                availableAuthors = try repository.fetchAuthors()
                if selectedAuthor == nil {
                    selectedAuthor = availableAuthors.first
                }
            } catch {
                presentError(error)
            }
        }
    }

    func createArtItem() async {
        guard canCreate,
              let coordinate = selectedCoordinate,
              let selectedLocationName,
              let selectedAuthor,
              let selectedCategory else {
            presentError(APIError.invalidRequest)
            return
        }

        isCreateButtonDisabled = true
        defer { isCreateButtonDisabled = false }

        do {
            _ = try await repository.createArtItem(
                title: title,
                description: description,
                locationName: selectedLocationName,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude,
                author: selectedAuthor,
                category: selectedCategory
            )
            didCreateArtItem = true
        } catch {
            presentError(error)
        }
    }

    func dismissError() {
        errorMessage = nil
        isErrorAlertPresented = false
    }

    private func presentError(_ error: Error) {
        if let apiError = error as? APIErrorResponse {
            errorMessage = apiError.errorMessage
        } else {
            errorMessage = error.localizedDescription
        }
        isErrorAlertPresented = true
    }
}
