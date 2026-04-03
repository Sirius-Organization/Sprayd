//
//  UserProfileView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct UserProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let postedSectionText: String = "Posted"
        static let visitedSectionText: String = "Visited"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let profileImageCornerRadius: CGFloat = profileImageSize / 2
        static let usernameDescriptionSpacing: CGFloat = 13
        
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
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                .cornerRadius(Const.profileImageCornerRadius)
                .frame(maxWidth: .infinity)
            VStack(spacing: Const.usernameDescriptionSpacing) {
                HStack {
                    Text("Username")
                        .font(Const.usernameFont)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Description")
                        .font(Const.descriptionFont)
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
        Text(Const.postedSectionText)
            .frame(maxWidth: 150)
            .font(Const.sectionTitleFont)
    }
    
    // TODO: - Replace with an array of posts
    private var postView: some View = ArtMediumCardView()
        
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                        .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    bioView
                    
                    pickerView
                    
                    sectionTitle
                                        
                    postView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    UserProfileView()
}
