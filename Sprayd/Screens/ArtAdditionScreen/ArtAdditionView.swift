//
//  ArtAdditionView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI
import CoreLocation

struct ArtAdditionView: View {
    // MARK: - Constants
    private enum Const {
        // UI Constraint properties
        static let photoItemHeight: CGFloat = 136
        static let photoItemWidth: CGFloat = 127
        static let photoItemCornerRadius: CGFloat = 30
        static let authorAvatarSize: CGFloat = 42
        static let createButtonHeight: CGFloat = 48
        static let createButtonCornerRadius: CGFloat = 24
        static let narrowInputFieldHeight: CGFloat = 44
        static let wideInputFieldHeight: CGFloat = 120
        
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
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $viewModel.isLocationPickerPresented) {
            LocationPickerView { picked in
                viewModel.selectedCoordinate = picked.coordinate
                viewModel.selectedLocationName = picked.displayName
            }
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
                .foregroundStyle(Color.black)
        }
        .frame(height: 44)
    }
    
    private var photoSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Metrics.oneAndHalfModule) {
                choosePhotoButton
                
                ForEach(viewModel.addedPhotos) { photo in
                        photoPreview(photo)
                    }
            }
            .padding(.vertical, Metrics.halfModule)
        }
    }
    
    private var choosePhotoButton: some View {
        Button {
            // TODO: - Open photo choice screen
        } label: {
            VStack(spacing: Metrics.oneAndHalfModule) {
                Icons.photo
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color.white)
                
                Text("Add a picture*")
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
            Text("Author")
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.black)
            
            if let selectedAuthor = viewModel.selectedAuthor {
                HStack(spacing: Metrics.oneAndHalfModule) {
                    Circle()
                        .fill(Color.gray.opacity(0.45))
                        .frame(width: Const.authorAvatarSize, height: Const.authorAvatarSize)
                        .overlay {
                            Icons.person
                                .foregroundStyle(Color.white.opacity(0.9))
                        }
                    
                    Text(selectedAuthor.name)
                        .font(.InstrumentMedium18)
                        .foregroundStyle(Color.black)
                }
            }
            
            BlackSelectCapsuleButton(
                title: "Select an author"
            ) {
                // TODO: open author picker
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text("Location")
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
                .foregroundStyle(Color.black)
            
            if let selectedCategory = viewModel.selectedCategory {
                CategoryCapsule(title: selectedCategory.name)
            }
            
            BlackSelectCapsuleButton(
                title: "Select category"
            ) {
                // TODO: open category picker
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
                
                Text("Create")
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
    func photoPreview(_ photo: ArtImage) -> some View {
        RoundedRectangle(cornerRadius: Const.photoItemCornerRadius)
            .fill(Color.placeholderGrey)
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
    }
    
    private static func formatCoordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}

//// MARK: - Preview
//#Preview {
//    ArtAdditionView()
//}
