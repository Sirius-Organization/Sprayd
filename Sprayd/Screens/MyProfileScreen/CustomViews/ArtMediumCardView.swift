//
//  ArtMediumCardView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct ArtMediumCardView: View {
    // MARK: - Constants
    private enum Const {
        // UI constraint properties
        static let cardHorizontalPadding: CGFloat = 24
        static let cardTopPadding: CGFloat = 22
        
        static let imageHeight: CGFloat = 318
        static let imageCornerRadius: CGFloat = 30
        
        static let contentSpacing: CGFloat = 18
        static let sectionSpacing: CGFloat = 10
        static let peopleBlockSpacing: CGFloat = 14
        
        static let titleToMetaSpacing: CGFloat = 6
        static let descriptionTopSpacing: CGFloat = 8
        
        static let heartIconSize: CGFloat = 18
        static let locationIconSize: CGFloat = 18
        
        // Fonts
        static let titleFont: Font = .custom("InstrumentSans-Bold", size: 20)
        static let likesFont: Font = .custom("InstrumentSans-Medium", size: 13)
        static let metaFont: Font = .custom("InstrumentSans-Regular", size: 13)
        static let descriptionFont: Font = .custom("InstrumentSans-Regular", size: 13)
        
        static let artworkAuthorSectionTitleFont: Font = .custom("InstrumentSans-Bold", size: 13)
        static let postAuthorSectionTitleFont: Font = .custom("InstrumentSans-Regular", size: 13)
        
        // Colors
        static let heartColor = Color.accentRed
        
        static let placeholderColor = Color(
            red: 224 / 255,
            green: 224 / 255,
            blue: 224 / 255
        )
        
        // Text
        static let titleText = "The Gliders"
        static let likesText = "22"
        static let locationText = "St. Petersburg"
        static let dateText = "24.02.2025"
        static let descriptionText = "Mural by Ana Markov originally painted in 2015. It explores themes of loneliness and social issues. ..."
        static let artworkAuthorSectionTitle = "Author"
        static let artworkAuthorName = "Ana Markov"
        static let postAuthorSectionTitle = "Posted by"
        static let postAuthorName = "Loxxych"
        
        // Symbols
        static let placeholderImageName = "photo"
        
        // Icons
        static let heartIcon: String = "heartIcon"
        static let locationIcon: String = "locationIcon"
    }
    
    // MARK: - Subviews
    private var artworkImage: some View {
        RoundedRectangle(cornerRadius: Const.imageCornerRadius)
            .fill(Const.placeholderColor)
            .frame(maxWidth: .infinity)
            .frame(height: Const.imageHeight)
            .overlay {
                Image(systemName: Const.placeholderImageName)
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(Color.secondaryColor)
            }
    }
    
    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(Const.titleText)
                .font(Const.titleFont)
                .foregroundStyle(.black)
            
            Spacer(minLength: 12)
            
            HStack(spacing: 8) {
                Text(Const.likesText)
                    .font(Const.likesFont)
                    .foregroundStyle(.black)
                
                Image(Const.heartIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Const.heartIconSize, height: Const.heartIconSize)
                    .foregroundStyle(Const.heartColor)
            }
        }
    }
    
    private var metaRow: some View {
        HStack(alignment: .center) {
            Label {
                Text(Const.locationText)
                    .font(Const.metaFont)
            } icon: {
                Image(Const.locationIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Const.locationIconSize, height: Const.locationIconSize)
            }
            .foregroundStyle(Color.secondaryColor)
            
            Spacer(minLength: 12)
            
            Text(Const.dateText)
                .font(Const.metaFont)
                .foregroundStyle(Color.secondaryColor)
        }
    }
    
    private var descriptionText: some View {
        Text(Const.descriptionText)
            .font(Const.descriptionFont)
            .foregroundStyle(Color.secondaryColor)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, Const.descriptionTopSpacing)
    }
    
    private func personSection(title: String, titleFont: Font, name: String) -> some View {
        VStack(alignment: .leading, spacing: Const.sectionSpacing) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(Color.accentRed)
            
            MiniProfileView(name: name)
        }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Const.contentSpacing) {
                artworkImage
                
                VStack(alignment: .leading, spacing: Const.titleToMetaSpacing) {
                    titleRow
                    metaRow
                }
                
                descriptionText
                
                VStack(alignment: .leading, spacing: Const.peopleBlockSpacing) {
                    personSection(
                        title: Const.artworkAuthorSectionTitle,
                        titleFont: Const.artworkAuthorSectionTitleFont,
                        name: Const.artworkAuthorName
                    )
                    
                    personSection(
                        title: Const.postAuthorSectionTitle,
                        titleFont: Const.postAuthorSectionTitleFont,
                        name: Const.postAuthorName
                    )
                }
            }
            .padding(.horizontal, Const.cardHorizontalPadding)
            .padding(.top, Const.cardTopPadding)
            .padding(.bottom, Const.cardTopPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ArtMediumCardView()
}
