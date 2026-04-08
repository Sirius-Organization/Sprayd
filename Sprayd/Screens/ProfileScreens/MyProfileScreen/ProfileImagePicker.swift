//
//  ProfileImagePicker.swift
//  Sprayd
//
//  Created by loxxy on 07.04.2026.
//

import SwiftUI
import UIKit

struct ProfileImagePicker: UIViewControllerRepresentable {
    // MARK: - Fields
    let source: MyProfileViewModel.ProfileImageSource
    let onImagePicked: (UIImage) -> Void
    let onCancel: () -> Void
    
    // MARK: - Logic
    func makeCoordinator() -> ImagePickerDelegate {
        ImagePickerDelegate(onImagePicked: onImagePicked, onCancel: onCancel)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = source == .camera ? .camera : .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    final class ImagePickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let onImagePicked: (UIImage) -> Void
        private let onCancel: () -> Void
        
        init(onImagePicked: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onImagePicked = onImagePicked
            self.onCancel = onCancel
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            } else {
                onCancel()
            }
        }
    }
}
