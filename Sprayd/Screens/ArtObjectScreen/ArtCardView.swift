//
//  ArtCardView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import SwiftUI

struct ArtCardView: View {
    // MARK: - Constants
    private enum Const {
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
        
        static let placeholderColor = Color(
            red: 224 / 255,
            green: 224 / 255,
            blue: 224 / 255
        )
        
        // Text
        static let titleText = "The Gliders"
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
        static let filledHeartIcon: String = "filledHeartIcon"
        static let locationIcon: String = "locationIcon"
    }
    
    // MARK: - Fields
    @State private var isLiked: Bool = false
    @State private var likesCount: Int = 0
    private var currentHeartIcon: String {
        isLiked ? Const.filledHeartIcon : Const.heartIcon
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
                .font(Font.InstrumentBold20)
                .foregroundStyle(.black)
            
            Spacer(minLength: 12)
            
            HStack(spacing: 8) {
                Text(String(likesCount))
                    .font(Font.InstrumentMedium13)
                    .foregroundStyle(.black)
                
                
                Image(currentHeartIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Const.heartIconSize, height: Const.heartIconSize)
                    .foregroundStyle(Color.accentRed)
                    .onTapGesture {
                        toggleLike()
                    }
                
            }
        }
    }
    
    private var metaRow: some View {
        HStack(alignment: .center) {
            Label {
                Text(Const.locationText)
                    .font(Font.InstrumentRegular13)
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
                .font(Font.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
    }
    
    private var descriptionText: some View {
        Text(Const.descriptionText)
            .font(Font.InstrumentBold13)
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
                        titleFont: Font.InstrumentBold13,
                        name: Const.artworkAuthorName
                    )
                    
                    personSection(
                        title: Const.postAuthorSectionTitle,
                        titleFont: Font.InstrumentBold13,
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
    
    // MARK: - Display logic
    private func toggleLike() {
        isLiked.toggle()
        
        if (isLiked) {
            likesCount += 1
        } else {
            likesCount -= 1
        }
    }
}

#Preview {
    ArtMediumCardView()
}
