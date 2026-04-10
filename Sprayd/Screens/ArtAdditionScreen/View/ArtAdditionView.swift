//
//  ArtAdditionView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI
import CoreLocation
import UIKit

struct ArtAdditionView: View {
    // MARK: - Constants
    private enum Const {
        static let photoItemHeight: CGFloat = 136
        static let photoItemWidth: CGFloat = 127
        static let photoItemCornerRadius: CGFloat = 30
        static let createButtonHeight: CGFloat = 48
        static let createButtonCornerRadius: CGFloat = 24
        static let narrowInputFieldHeight: CGFloat = 44
        static let wideInputFieldHeight: CGFloat = 120
        static let iconFont: Font = .system(size: 16, weight: .medium)
    }
    
    // MARK: - Fields
    @ObservedObject private var viewModel: ArtAdditionViewModel
    
    let onBackButtonTapped: () -> Void
    
    // MARK: - Lifecycle
    init(
        onBackButtonTapped: @escaping () -> Void,
        viewModel: ArtAdditionViewModel
    ) {
        self.onBackButtonTapped = onBackButtonTapped
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            if viewModel.isImageSourceDialogPresented {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            viewModel.dismissImageOptions()
                        }
                    }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: Metrics.tripleModule) {
                    headerView
                    photoSection
                    
                    OutlinedInputField(
                        minHeight: Const.narrowInputFieldHeight,
                        axis: .horizontal,
                        title: "Title",
                        placeholder: "Add a title*",
                        text: $viewModel.title
                    )
                    
                    OutlinedInputField(
                        minHeight: Const.wideInputFieldHeight,
                        axis: .vertical,
                        title: "Description",
                        placeholder: "Add a description*",
                        text: $viewModel.description
                    )
                    
                    authorSection
                    locationSection
                    categorySection
                    createButton
                        .padding(.top, Metrics.tripleModule)
                        .padding(.bottom, Metrics.twoAndHalfModule)
                }
                .padding(.horizontal, Metrics.tripleModule)
                .padding(.top, Metrics.twoAndHalfModule)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .dismissKeyboardOnTap()
        .task {
            await viewModel.loadInitialDataIfNeeded()
        }
        .onChange(of: viewModel.didCreateArtItem) { _, didCreateArtItem in
            guard didCreateArtItem else { return }
            onBackButtonTapped()
        }
        .sheet(item: $viewModel.activeImagePickerSource) { source in
            ImagePickerView(
                source: source,
                selectionLimit: 0,
                onImagesPicked: { images in
                    viewModel.addPickedImages(images)
                    viewModel.dismissImagePicker()
                },
                onCancel: {
                    viewModel.dismissImagePicker()
                }
            )
        }
        .sheet(isPresented: $viewModel.isLocationPickerPresented) {
            LocationPickerView { picked in
                viewModel.selectedCoordinate = picked.coordinate
                viewModel.selectedLocationName = picked.displayName
            }
        }
        .sheet(isPresented: $viewModel.isAuthorPickerPresented) {
            AuthorPickerView(
                viewModel: viewModel
            ) { author in
                viewModel.selectedAuthor = author
            }
        }
        .sheet(isPresented: $viewModel.isCategoryPickerPresented) {
            CategoryPickerView(
                viewModel: viewModel
            ) { category in
                viewModel.selectedCategory = category
            }
        }
        .alert("Access Needed", isPresented: $viewModel.isPermissionAlertPresented) {
            if viewModel.shouldOfferSettingsRedirect {
                Button("Settings") {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsURL)
                    viewModel.dismissPermissionAlert()
                }
            }
            
            Button("OK", role: .cancel) {
                viewModel.dismissPermissionAlert()
            }
        } message: {
            Text(viewModel.permissionAlertMessage)
        }
        .alert("Error", isPresented: $viewModel.isErrorAlertPresented) {
            Button("OK", role: .cancel) {
                viewModel.dismissError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong")
        }
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        ZStack {
            HStack {
                Button {
                    onBackButtonTapped()
                } label: {
                    Icons.leftArrow
                }
                
                Spacer()
            }
            
            Text("Add new art")
                .font(.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)
        }
        .frame(height: 44)
    }
    
    private var photoSection: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Metrics.oneAndHalfModule) {
                    choosePhotoButton
                    
                    ForEach(viewModel.addedPhotos) { photo in
                        photoPreview(photo)
                    }
                }
                .padding(.vertical, Metrics.halfModule)
            }
            
            if viewModel.isImageSourceDialogPresented {
                ImageOptionsMenu(
                    choosePhotoLibrary: {
                        viewModel.choosePhotoLibrary()
                    },
                    chooseCamera: {
                        viewModel.chooseCamera()
                    }
                )
                .padding(.trailing, Metrics.module)
                .offset(y: Metrics.doubleModule)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    )
                )
                .zIndex(1)
            }
        }
    }
    
    private var choosePhotoButton: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                viewModel.toggleImageOptions()
            }
        } label: {
            VStack(spacing: Metrics.oneAndHalfModule) {
                Icons.photo
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color.appContrastForeground)
                
                Text("Add a picture*")
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.appContrastForeground)
            }
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: Const.photoItemCornerRadius))
        }
    }
    
    var authorSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text("Author")
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.appPrimaryText)
            
            if let selectedAuthor = viewModel.selectedAuthor {
                MiniProfileView(name: selectedAuthor.name)
            }
            
            BlackSelectCapsuleButton(
                title: "Select an author"
            ) {
                viewModel.isAuthorPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text("Location")
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.appPrimaryText)
            
            if let selectedCoordinate = viewModel.selectedCoordinate {
                HStack(alignment: .top, spacing: Metrics.halfModule) {
                    Icons.location
                        .foregroundStyle(Color.secondaryColor)
                    
                    VStack(alignment: .leading, spacing: Metrics.halfModule) {
                        let coordText = Self.formatCoordinate(selectedCoordinate)
                        if let selectedLocationName = viewModel.selectedLocationName {
                            Text(selectedLocationName)
                                .font(.InstrumentMedium16)
                                .foregroundStyle(Color.appPrimaryText)
                        }
                        if viewModel.selectedLocationName != coordText {
                            Text(coordText)
                                .font(.InstrumentRegular13)
                                .foregroundStyle(Color.secondaryColor)
                        }
                    }
                }
            }
            
            BlackSelectCapsuleButton(
                title: "Add location"
            ) {
                viewModel.isLocationPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text("Category")
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.appPrimaryText)
            
            if let selectedCategory = viewModel.selectedCategory {
                CategoryCapsule(title: selectedCategory.name)
            }
            
            BlackSelectCapsuleButton(
                title: "Select category"
            ) {
                viewModel.isCategoryPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var createButton: some View {
        Button {
            Task {
                await viewModel.createArtItem()
            }
        } label: {
            HStack {
                Spacer()
                
                Text("Create")
                    .font(.InstrumentMedium20)
                    .foregroundStyle(Color.appContrastForeground)
                
                Spacer()
                
                Icons.checkmark
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.createButtonHeight)
            .background(viewModel.canCreate ? Color.accentRed : Color.placeholderGrey)
            .clipShape(RoundedRectangle(cornerRadius: Const.createButtonCornerRadius))
        }
        .disabled(!viewModel.canCreate)
        .padding(.horizontal, Metrics.quadrupleModule)
    }
    
    // MARK: - Utility
    func photoPreview(_ photo: ArtAdditionViewModel.SelectedPhoto) -> some View {
        Image(uiImage: photo.image)
            .resizable()
            .scaledToFill()
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
            .clipShape(RoundedRectangle(cornerRadius: Const.photoItemCornerRadius))
    }
    
    private static func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}
