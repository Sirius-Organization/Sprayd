//
//  ArtAdditionView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

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
        static let addressFieldTitle: String = "Address"
        static let addressFieldPlaceholder: String = "Add an address*"
        static let addPictureText: String = "Add a picture*"

        // Fonts
        static let iconFont: Font = .system(size: 16, weight: .medium)
    }
    
    // MARK: - Fields
    private var addedPhotos: [Photo] = []
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var address: String = "The UK, St. Andrew’s, New Avenue st. 22"
    @State private var selectedAuthor: Author? = Author(name: "Ana Markov")
    @State private var selectedCategory: Category? = Category(name: "Sponsored by government")
    
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
                        title: Const.titleFieldTitle,
                        placeholder: Const.titleFieldPlaceholder,
                        text: $title
                    )
                    
                    OutlinedInputField(
                        minHeight: Const.wideInputFieldHeight,
                        axis: .vertical,
                        title: Const.descriptionFieldTitle,
                        placeholder: Const.descriptionFieldPlaceholder,
                        text: $title
                    )
                    
                    authorSection
                    
                    OutlinedInputField(
                        minHeight: Const.narrowInputFieldHeight,
                        axis: .horizontal,
                        title: Const.addressFieldTitle,
                        placeholder: Const.addressFieldPlaceholder,
                        text: $address
                    )
                    
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
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        ZStack {
            HStack {
                Button {
                    // TODO: back action
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Metrics.oneAndHalfModule) {
                choosePhotoButton
                
                ForEach(addedPhotos) { photo in
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
            
            if let selectedAuthor {
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
                title: Const.selectAuthButtonText
            ) {
                // TODO: open author picker
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(Const.categoryText)
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.black)
            
            if let selectedCategory {
                CategoryCapsule(title: selectedCategory.name)
            }
            
            BlackSelectCapsuleButton(
                title: Const.selectCategoryButtonText
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
    func photoPreview(_ photo: Photo) -> some View {
        RoundedRectangle(cornerRadius: Const.photoItemCornerRadius)
            .fill(Color.placeholderGrey)
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
    }
}

// MARK: - Preview
#Preview {
    ArtAdditionView()
}
