//
//  MyProfileViewModel.swift
//  Sprayd
//
//  Created by loxxy on 04.04.2026.
//

import SwiftUI
import AVFoundation
import Photos
import UIKit
internal import Combine

final class MyProfileViewModel: ObservableObject {
    enum ProfileImageSource: String, Identifiable {
        case photoLibrary
        case camera
        
        var id: String { rawValue }
    }
    
    enum Option: String {
        case posted = "Posted"
        case visited = "Visited"
    }
    
    // MARK: - Fields
    @Published var selectedOption: Option
    @Published var username: String
    @Published var draftUsername: String = ""
    @Published var bio: String
    @Published var draftBio: String = ""
    @Published var posts: [ArtItem]
    @Published var visited: [ArtItem]
    @Published var profileImage: UIImage?
    
    @Published var isImageSourceDialogPresented: Bool = false
    @Published var activeImagePickerSource: ProfileImageSource?
    @Published var isPermissionAlertPresented: Bool = false
    @Published var permissionAlertMessage: String = ""
    @Published var shouldOfferSettingsRedirect: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @Published var isEditingUsername: Bool = false
    @Published var isEditingBio: Bool = false
    
    var selectedOptionTitle: String {
        selectedOption.rawValue
    }
    
    var shouldDisplayAddButton: Bool {
        selectedOption == .posted
    }
    
    var displayedItems: [ArtItem]? {
        selectedOption == .posted ? posts : visited
    }
    
    // MARK: - Lifecycle
    init(
        selectedOption: Option = .posted,
        username: String = "Username",
        bio: String = "Description",
        posts: [ArtItem] = [ArtItem(name: "ArtWork1", author: "Author"), ArtItem(name: "ArtWork2", author: "Author")],
        visited: [ArtItem] = [ArtItem(name: "ArtWork3", author: "Author")],
    ) {
        self.selectedOption = selectedOption
        self.username = username
        self.bio = bio
        self.posts = posts
        self.visited = visited
    }
    
    // MARK: - Logic
    func selectOption(_ option: Option) {
        selectedOption = option
    }
    
    func enterUsernameEditingMode() {
        draftUsername = username
        isEditingUsername.toggle()
    }
    
    func saveUsername() {
        username = draftUsername
        isEditingUsername.toggle()
    }
    
    func enterBioEditingMode() {
        isEditingBio.toggle()
        draftBio = bio
    }

    func saveBio() {
        bio = draftBio
        isEditingBio.toggle()
    }
    
    func presentProfileImageOptions() {
        isImageSourceDialogPresented.toggle()
    }
    
    func dismissProfileImageOptions() {
        isImageSourceDialogPresented = false
    }
    
    func choosePhotoLibrary() {
        dismissProfileImageOptions()
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
                            message: "Allow access to your photo library to choose a profile picture.",
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
        dismissProfileImageOptions()
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
                            message: "Allow camera access to take a profile picture.",
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
    
    func updateProfileImage(_ image: UIImage) {
        profileImage = image
    }
    
    func dismissImagePicker() {
        activeImagePickerSource = nil
    }
    
    func dismissPermissionAlert() {
        isPermissionAlertPresented = false
        permissionAlertMessage = ""
        shouldOfferSettingsRedirect = false
    }
    
    private func presentPermissionAlert(message: String, offerSettingsRedirect: Bool) {
        permissionAlertMessage = message
        shouldOfferSettingsRedirect = offerSettingsRedirect
        isPermissionAlertPresented = true
    }
}
