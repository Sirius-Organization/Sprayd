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
        
        static let screenHorizontalPadding: CGFloat = 25
        static let sectionSpacing: CGFloat = 14
        
        static let authorAvatarSize: CGFloat = 42
        
        static let createButtonHeight: CGFloat = 48
        static let createButtonCornerRadius: CGFloat = 24
        static let createButtonHorizontalPadding: CGFloat = 32
        
        static let narrowInputFieldHeight: CGFloat = 44
        static let wideInputFieldHeight: CGFloat = 120

        static let mainSpacing: CGFloat = 23
        
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
        static let sectionTitleFont: Font = .InstrumentMedium16
        static let headerTitleFont: Font = .InstrumentBold20
        static let inputTextFont: Font = .InstrumentRegular18
        static let sectionTextFont: Font = .InstrumentMedium18
        static let bodyTextFont: Font = .InstrumentMedium18
        static let createButtonFont: Font = .InstrumentMedium20
        static let addPhotoButtonFont: Font = .InstrumentRegular13
        
        // Icons
        static let photoIcon: String = "photo"
        static let rightArrowIcon: String = "rightArrowIcon"
        static let leftArrowIcon: String = "leftArrowIcon"
        static let authorPlaceholderIcon: String = "person.fill"
        static let createButtonIcon: String = "checkIcon"
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
                VStack(alignment: .leading, spacing: Const.mainSpacing) {
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
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, Const.screenHorizontalPadding)
                .padding(.top, 18)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        ZStack {
            HStack {
                Button {
                    // TODO: back action
                } label: {
                    Image(Const.leftArrowIcon)
                }
                
                Spacer()
            }
            
            Text(Const.headerText)
                .font(Const.headerTitleFont)
                .foregroundStyle(Color.black)
        }
        .frame(height: 44)
    }
    
    private var photoSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                choosePhotoButton
                
                ForEach(addedPhotos) { photo in
                    photoPreview(photo)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var choosePhotoButton: some View {
        Button {
            // TODO: - Open photo choice screen
        } label: {
            VStack(spacing: 10) {
                Image(systemName: Const.photoIcon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color.white)
                
                Text(Const.addPictureText)
                    .font(Const.addPhotoButtonFont)
                    .foregroundStyle(Color.white)
            }
            .frame(width: Const.photoItemWidth, height: Const.photoItemHeight)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: Const.photoItemCornerRadius))
        }
    }
    
    var authorSection: some View {
        VStack(alignment: .leading, spacing: Const.sectionSpacing) {
            Text(Const.authorSectionTitleText)
                .font(Const.sectionTextFont)
                .foregroundStyle(Color.black)
            
            if let selectedAuthor {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.gray.opacity(0.45))
                        .frame(width: Const.authorAvatarSize, height: Const.authorAvatarSize)
                        .overlay {
                            Image(systemName: Const.authorPlaceholderIcon)
                                .foregroundStyle(Color.white.opacity(0.9))
                        }
                    
                    Text(selectedAuthor.name)
                        .font(Const.bodyTextFont)
                        .foregroundStyle(Color.black)
                }
            }
            
            BlackSelectCapsuleButton(
                title: Const.selectAuthButtonText,
                iconName: Const.rightArrowIcon
            ) {
                // TODO: open author picker
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: Const.sectionSpacing) {
            Text(Const.categoryText)
                .font(Const.sectionTextFont)
                .foregroundStyle(Color.black)
            
            if let selectedCategory {
                CategoryCapsule(title: selectedCategory.name)
            }
            
            BlackSelectCapsuleButton(
                title: Const.selectCategoryButtonText,
                iconName: Const.rightArrowIcon
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
                    .font(Const.createButtonFont)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                Image(Const.createButtonIcon)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 28)
            .frame(height: Const.createButtonHeight)
            .background(Color.accentRed)
            .clipShape(RoundedRectangle(cornerRadius: Const.createButtonCornerRadius))
        }
        .padding(.horizontal, Const.createButtonHorizontalPadding)
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
