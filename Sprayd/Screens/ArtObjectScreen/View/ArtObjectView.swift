//
//  ArtObjectView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI
import UIKit

struct ArtObjectView: View {
    @State private var viewModel = ArtObjectViewModel.sample
    @State private var showContributeSourceDialog = false
    @State private var contributePickerSource: ContributePickerSource?

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea(edges: .all)
                ScrollView {
                    Spacer(minLength: Metrics.twoAndHalfModule)
                    ArtCardView(viewModel: self.viewModel)

                    VStack(spacing: Metrics.oneAndHalfModule) {
                        markVisitedButton
                        contributeButton
                    }
                    .padding(.horizontal, Metrics.tenTimesModule)
                    .padding(.top, Metrics.doubleModule)
                }
            }
            .navigationDestination(isPresented: $viewModel.isPhotoPreviewPresented) {
                PhotoView(
                    selectedPhotoIndex: $viewModel.selectedPhotoIndex,
                    photoImageNames: self.viewModel.photoImageNames
                )
            }
            .confirmationDialog("Add a photo", isPresented: $showContributeSourceDialog, titleVisibility: .visible) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("Take Photo") {
                        contributePickerSource = .camera
                    }
                }
                Button("Photo Library") {
                    contributePickerSource = .photoLibrary
                }
                Button("Cancel", role: .cancel) {}
            }
            .fullScreenCover(item: $contributePickerSource) { source in
                UIImagePickerBridge(
                    sourceType: source.imagePickerSourceType,
                    onDismiss: { contributePickerSource = nil }
                )
                .ignoresSafeArea()
            }
        }
    }

    private var markVisitedButton: some View {
        Button {
            viewModel.toggleVisited()
        } label: {
            HStack {
                Text(viewModel.isVisited ? "Marked visited" : "Mark visited")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Icons.checkmark
                    .renderingMode(.template)
                    .foregroundColor(.black)
            }
            .foregroundStyle(viewModel.isVisited ? .white : .primary)
            .padding(.horizontal, Metrics.twoAndHalfModule)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                viewModel.isVisited
                    ? AnyShapeStyle(Color.accentRed)
                    : AnyShapeStyle(Color.clear)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary, lineWidth: viewModel.isVisited ? 0 : 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isVisited)
    }

    private var contributeButton: some View {
        Button {
            showContributeSourceDialog = true
        } label: {
            HStack {
                Text("Contribute")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Icons.camera
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Metrics.twoAndHalfModule)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Contribute media pickers

private enum ContributePickerSource: Identifiable {
    case camera
    case photoLibrary

    var id: Self { self }

    var imagePickerSourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera: return .camera
        case .photoLibrary: return .photoLibrary
        }
    }
}

private struct UIImagePickerBridge: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onDismiss: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            onDismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onDismiss()
        }
    }
}

#Preview {
    ArtObjectView()
}
