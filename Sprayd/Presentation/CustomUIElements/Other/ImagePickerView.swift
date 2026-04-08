//
//  ImagePickerView.swift
//  Sprayd
//

import PhotosUI
import SwiftUI
import UIKit

enum ImagePickerSource: String, Identifiable {
    case photoLibrary
    case camera
    
    var id: String { rawValue }
}

struct ImagePickerView: UIViewControllerRepresentable {
    // MARK: - Fields
    let source: ImagePickerSource
    let selectionLimit: Int
    let onImagesPicked: ([UIImage]) -> Void
    let onCancel: () -> Void
    
    // MARK: - Logic
    func makeCoordinator() -> Coordinator {
        Coordinator(
            source: source,
            onImagesPicked: onImagesPicked,
            onCancel: onCancel
        )
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        switch source {
        case .camera:
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.allowsEditing = false
            picker.sourceType = .camera
            return picker
        case .photoLibrary:
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = selectionLimit
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
        private let source: ImagePickerSource
        private let onImagesPicked: ([UIImage]) -> Void
        private let onCancel: () -> Void
        
        init(
            source: ImagePickerSource,
            onImagesPicked: @escaping ([UIImage]) -> Void,
            onCancel: @escaping () -> Void
        ) {
            self.source = source
            self.onImagesPicked = onImagesPicked
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
                onImagesPicked([image])
            } else {
                onCancel()
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else {
                onCancel()
                return
            }
            
            Task {
                let images = await loadImages(from: results)
                await MainActor.run {
                    if images.isEmpty {
                        onCancel()
                    } else {
                        onImagesPicked(images)
                    }
                }
            }
        }
        
        private func loadImages(from results: [PHPickerResult]) async -> [UIImage] {
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, result) in results.enumerated() {
                    group.addTask {
                        let image = await self.loadImage(from: result)
                        return (index, image)
                    }
                }
                
                var indexedImages: [(Int, UIImage)] = []
                
                for await (index, image) in group {
                    if let image {
                        indexedImages.append((index, image))
                    }
                }
                
                return indexedImages
                    .sorted { $0.0 < $1.0 }
                    .map(\.1)
            }
        }
        
        private func loadImage(from result: PHPickerResult) async -> UIImage? {
            guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return nil }
            
            return await withCheckedContinuation { continuation in
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    continuation.resume(returning: object as? UIImage)
                }
            }
        }
    }
}
