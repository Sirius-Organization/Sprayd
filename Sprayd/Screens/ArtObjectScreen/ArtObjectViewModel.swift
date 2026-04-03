//
//  ArtObjectViewModel.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 02.04.2026.
//

import Foundation

@Observable
final class ArtObjectViewModel {
    struct PhotoItem: Identifiable {
        let index: Int
        let imageName: String

        var id: Int { index }
    }

    static let photoImageNames = ["art", "bird", "cube"]
    static let photoItems = photoImageNames.enumerated().map {
        PhotoItem(index: $0.offset, imageName: $0.element)
    }

    var selectedPhotoIndex = 0
    var isPhotoPreviewPresented = false

    func openPhotoPreview(named imageName: String) {
        if let index = Self.photoImageNames.firstIndex(of: imageName) {
            selectedPhotoIndex = index
        }
        isPhotoPreviewPresented = true
    }
}
