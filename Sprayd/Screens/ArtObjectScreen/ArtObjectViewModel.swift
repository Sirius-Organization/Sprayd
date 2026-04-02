//
//  ArtObjectViewModel.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 02.04.2026.
//

import Foundation

@Observable
final class ArtObjectViewModel {
    /// Same order as assets used in `PhotoPagerView` / `ArtObjectPhotoPreviewView`.
    static let photoImageNames = ["art", "bird", "cube"]

    var selectedPhotoIndex = 0
    var isPhotoPreviewPresented = false

    func openPhotoPreview(named imageName: String) {
        if let index = Self.photoImageNames.firstIndex(of: imageName) {
            selectedPhotoIndex = index
        }
        isPhotoPreviewPresented = true
    }
}

