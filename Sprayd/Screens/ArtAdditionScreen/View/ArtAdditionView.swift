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
        // UI Constraint properties
        static let photoItemHeight: CGFloat = 136
        static let photoItemWidth: CGFloat = 127
        static let photoItemCornerRadius: CGFloat = 30
        static let createButtonHeight: CGFloat = 48
        static let createButtonCornerRadius: CGFloat = 24
        static let narrowInputFieldHeight: CGFloat = 44
        static let wideInputFieldHeight: CGFloat = 120
        
        // Strings
        static let authorSectionTitleText: String = "Author"
        static let selectAuthButtonText: String = "Select an author"
        static let selectCategoryButtonText: String = "Select category"
        static let headerText: String = "Add new art"
        static let createButtonText: String = "Create"
        static let categoryText: String = "Category"
        static let titleFieldTitle: String = "Title"
        static let titleFieldPlaceholder: String = "Add a title*"
        static let descriptionFieldTitle: String = "Description"
        static let descriptionFieldPlaceholder: String = "Add a description*"
        static let locationSectionTitle: String = "Location"
        static let addLocationButtonText: String = "Add location"
        static let addPictureText: String = "Add a picture*"
        
        // Fonts
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
            Color(Color.appBackground)
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
                        title: Const.titleFieldTitle,
                        placeholder: Const.titleFieldPlaceholder,
                        text: $viewModel.title
                    )
                    
                    OutlinedInputField(
                        minHeight: Const.wideInputFieldHeight,
                        axis: .vertical,
                        title: Const.descriptionFieldTitle,
                        placeholder: Const.descriptionFieldPlaceholder,
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
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
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
            
            Text(Const.headerText)
                .font(.InstrumentBold20)
                .foregroundStyle(Color.black)
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
                    .foregroundStyle(Color.white)
                
                Text(Const.addPictureText)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.white)
            }
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: Const.photoItemCornerRadius))
        }
    }
    
    var authorSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(Const.authorSectionTitleText)
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.black)
            
            if let selectedAuthor = viewModel.selectedAuthor {
                MiniProfileView(name: selectedAuthor.name)
            }
            
            BlackSelectCapsuleButton(
                title: Const.selectAuthButtonText
            ) {
                viewModel.isAuthorPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(Const.locationSectionTitle)
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.black)
            
            if let selectedCoordinate = viewModel.selectedCoordinate {
                HStack(alignment: .top, spacing: Metrics.halfModule) {
                    Icons.location
                        .foregroundStyle(Color.secondaryColor)
                    
                    VStack(alignment: .leading, spacing: Metrics.halfModule) {
                        let coordText = Self.formatCoordinate(selectedCoordinate)
                        if let selectedLocationName = viewModel.selectedLocationName{
                            Text(selectedLocationName)
                                .font(.InstrumentMedium16)
                                .foregroundStyle(Color.black)
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
                title: Const.addLocationButtonText
            ) {
                viewModel.isLocationPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(Const.categoryText)
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.black)
            
            if let selectedCategory = viewModel.selectedCategory {
                CategoryCapsule(title: selectedCategory.name)
            }
            
            BlackSelectCapsuleButton(
                title: Const.selectCategoryButtonText
            ) {
                viewModel.isCategoryPickerPresented = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var createButton: some View {
        Button {
            // TODO: create object action
        } label: {
            HStack {
                Spacer()
                
                Text(Const.createButtonText)
                    .font(.InstrumentMedium20)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                Icons.checkmark
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.createButtonHeight)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: Const.createButtonCornerRadius))
        }
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

//// MARK: - Preview
//#Preview {
//    ArtAdditionView()
//}
