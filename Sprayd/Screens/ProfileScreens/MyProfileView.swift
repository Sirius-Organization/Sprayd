//
//  ProfileView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let postedButtonBottomText: String = "Add new seen art"
        
        static let vButtonBottomText: String = "Add new seen art"
        
        static let postedSectionText: String = "Posted"
        static let visitedSectionText: String = "Visited"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let profileImageCornerRadius: CGFloat = profileImageSize / 2
        
        static let usernameDescriptionSpacing: CGFloat = 13
        
        static let choosePhotoButtonSize: CGFloat = 40
        static let choosePhotoButtonOffset: CGFloat = -6
        
        static let mainStackSpacing: CGFloat = 16
        
        // Fonts
        static let usernameFont: Font = .custom("Climate Crisis", size: 22)
        static let descriptionFont: Font = .custom("InstrumentSans-Medium", size: 13)
        static let optionsFont: Font = .custom("InstrumentSans-Medium", size: 16)
        static let sectionTitleFont: Font = .custom("Climate Crisis", size: 20)
        static let buttonBottomTextFont: Font = .custom("InstrumentSans-Medium", size: 13)
    }
    
    // MARK: - Fields
    @State private var selectedOption = "Posted"
    private var posts: [Post]?
    
    // MARK: - Subviews
    private var bioView: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                    .clipShape(Circle())

                Button {
                    // TODO: - Open photo choice screen
                } label: {
                    Image(systemName: "photo")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.accentRed)
                        .frame(width: Const.choosePhotoButtonSize, height: Const.choosePhotoButtonSize)
                        .background(Color.black)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .offset(x: Const.choosePhotoButtonOffset, y: Const.choosePhotoButtonOffset)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: Const.usernameDescriptionSpacing) {
                HStack {
                    Text("Username")
                        .font(Const.usernameFont)
                    Image(systemName: "pencil")
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Description")
                        .font(Const.descriptionFont)
                    Image(systemName: "pencil")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var pickerView: some View {
        Picker("", selection: $selectedOption) {
            Text(Const.postedSectionText).tag(Const.postedSectionText)
            Text(Const.visitedSectionText).tag(Const.visitedSectionText)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var sectionTitle: some View {
        Text(selectedOption)
            .frame(maxWidth: 150)
            .font(Const.sectionTitleFont)
    }
    
    private var addButtonView: some View {
        VStack(alignment: .center) {
            AddButton()
            
            Text(Const.postedButtonBottomText)
                .font(Const.buttonBottomTextFont)
        }
        .frame(maxWidth: .infinity)
    }
    
    // TODO: - Replace with an array of posts
    private var postView: some View = ArtMediumCardView()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Const.mainStackSpacing) {
                    bioView
                    
                    pickerView
                    
                    sectionTitle
                    
                    if selectedOption == Const.postedSectionText {
                        addButtonView
                    }
                    
                    postView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    ProfileView()
}
