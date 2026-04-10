//
//  ArtObjectView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI
import SwiftData
import UIKit

struct ArtObjectView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ArtObjectViewModel
    @State private var showContributeSourceDialog = false
    @State private var contributePickerSource: ContributePickerSource?
    private let onAuthorTap: (String) -> Void
    private let onPostedByTap: (String) -> Void

    init(
        item: ArtItem,
        onAuthorTap: @escaping (String) -> Void = { _ in },
        onPostedByTap: @escaping (String) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: ArtObjectViewModel(item: item))
        self.onAuthorTap = onAuthorTap
        self.onPostedByTap = onPostedByTap
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ZStack {
            Color.appBackground
                .ignoresSafeArea(edges: .all)
            ScrollView(showsIndicators: false) {
                VStack(spacing: Metrics.doubleModule) {

                    ArtCardView(
                        viewModel: self.viewModel,
                        onAuthorTap: {
                            let username = normalized(viewModel.author)
                            guard !username.isEmpty else { return }
                            onAuthorTap(username)
                        },
                        onPostedByTap: {
                            let username = normalized(viewModel.postedBy)
                            guard !username.isEmpty, username != "Unknown" else { return }
                            onPostedByTap(username)
                        }
                    )

                    VStack(spacing: Metrics.oneAndHalfModule) {
                        markVisitedButton
                        contributeButton
                    }
                    .padding(.horizontal, Metrics.tenTimesModule)
                }
                .padding(.top, Metrics.twoAndHalfModule)
                .padding(.bottom, Metrics.doubleModule)
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
        .task(id: viewModel.itemID) {
            await loadArtItemDetails()
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    @MainActor
    private func loadArtItemDetails() async {
        guard let itemID = viewModel.itemID else { return }

        do {
            let service = ArtSyncService(modelContext: modelContext)
            let item = try await service.syncArtItemDetails(for: itemID)
            viewModel.apply(item: item)
        } catch {
            print("Art item detail sync error:", error)
        }
    }

    private var markVisitedButton: some View {
        Button {
            viewModel.toggleVisited(in: modelContext)
        } label: {
            HStack {
                Text(viewModel.isVisited ? "Marked visited" : "Mark visited")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Icons.checkmark
                    .renderingMode(.template)
                    .foregroundColor(Color.appContrastForeground)
            }
            .foregroundStyle(viewModel.isVisited ? Color.appContrastForeground : Color.appPrimaryText)
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
                    .stroke(Color.appPrimaryText, lineWidth: viewModel.isVisited ? 0 : 1.5)
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
            .foregroundStyle(Color.appContrastForeground)
            .padding(.horizontal, Metrics.twoAndHalfModule)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.appContrastBackground)
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
