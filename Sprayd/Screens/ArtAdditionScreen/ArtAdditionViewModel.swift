//
//  ArtAdditionViewModel.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
import AVFoundation
import Photos
import UIKit
internal import Combine
import CoreLocation

@MainActor
final class ArtAdditionViewModel: ObservableObject {
    struct SelectedPhoto: Identifiable {
        let id = UUID()
        let image: UIImage
    }
    
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
    @Published var addedPhotos: [SelectedPhoto] = []
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedLocationName: String?
    @Published var isLocationPickerPresented: Bool = false
    @Published var isImageSourceDialogPresented: Bool = false
    @Published var activeImagePickerSource: ImagePickerSource?
    @Published var isPermissionAlertPresented: Bool = false
    @Published var permissionAlertMessage: String = ""
    @Published var shouldOfferSettingsRedirect: Bool = false
    @Published var isAuthorPickerPresented: Bool = false
    @Published var isCategoryPickerPresented: Bool = false
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
    }

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCoordinate != nil &&
        selectedLocationName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false &&
        !isCreateButtonDisabled
    }

    func loadInitialDataIfNeeded() async {
        guard !didLoadInitialData else { return }
        didLoadInitialData = true
        await loadInitialData()
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            availableAuthors = try await repository.syncArtists()
        } catch {
            do {
                availableAuthors = try repository.fetchAuthors()
            } catch {
                presentError(error)
            }
        }

        do {
            availableCategories = try await repository.fetchCategories()
        } catch {
            // Keep the local fallback categories for now if backend loading fails.
        }
    }

    func createArtItem() async {
        guard canCreate,
              let coordinate = selectedCoordinate,
              let selectedLocationName else {
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

    func toggleImageOptions() {
        isImageSourceDialogPresented.toggle()
    }
    
    func dismissImageOptions() {
        isImageSourceDialogPresented = false
    }
    
    func choosePhotoLibrary() {
        dismissImageOptions()
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            activeImagePickerSource = .photoLibrary
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    if status == .authorized || status == .limited {
                        self.activeImagePickerSource = .photoLibrary
                    } else {
                        self.presentPermissionAlert(
                            message: "Allow access to your photo library to choose art photos.",
                            offerSettingsRedirect: true
                        )
                    }
                }
            }
        case .denied, .restricted:
            presentPermissionAlert(
                message: "Photo library access is disabled. You can enable it in Settings.",
                offerSettingsRedirect: true
            )
        default:
            presentPermissionAlert(
                message: "Photo library access is unavailable right now.",
                offerSettingsRedirect: false
            )
        }
    }
    
    func chooseCamera() {
        dismissImageOptions()
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPermissionAlert(
                message: "Camera is not available on this device.",
                offerSettingsRedirect: false
            )
            return
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            activeImagePickerSource = .camera
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    if granted {
                        self.activeImagePickerSource = .camera
                    } else {
                        self.presentPermissionAlert(
                            message: "Allow camera access to take art photos.",
                            offerSettingsRedirect: true
                        )
                    }
                }
            }
        case .denied, .restricted:
            presentPermissionAlert(
                message: "Camera access is disabled. You can enable it in Settings.",
                offerSettingsRedirect: true
            )
        default:
            presentPermissionAlert(
                message: "Camera access is unavailable right now.",
                offerSettingsRedirect: false
            )
        }
    }
    
    func addPickedImages(_ images: [UIImage]) {
        let newPhotos = images.map { SelectedPhoto(image: $0) }
        addedPhotos.append(contentsOf: newPhotos)
    }
    
    func dismissImagePicker() {
        activeImagePickerSource = nil
    }
    
    func dismissPermissionAlert() {
        isPermissionAlertPresented = false
        permissionAlertMessage = ""
        shouldOfferSettingsRedirect = false
    }

    func dismissError() {
        errorMessage = nil
        isErrorAlertPresented = false
    }
    
    private func presentPermissionAlert(message: String, offerSettingsRedirect: Bool) {
        permissionAlertMessage = message
        shouldOfferSettingsRedirect = offerSettingsRedirect
        isPermissionAlertPresented = true
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
