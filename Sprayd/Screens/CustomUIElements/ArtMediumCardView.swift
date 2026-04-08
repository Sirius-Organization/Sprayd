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
        static let imageHeight: CGFloat = 318
        static let imageCornerRadius: CGFloat = 30
        
        static let placeholderColor = Color(
            red: 224 / 255,
            green: 224 / 255,
            blue: 224 / 255
        )
    }
    
    // MARK: - Lifecycle
    init(
        title: String,
        location: String,
        description: String,
        date: String,
        postAuthorName: String,
        artworkAuthorName: String,
        likesCount: Int = 0
    ) {
        self.title = title
        self.location = location
        self.description = description
        self.date = date
        self.postAuthorName = postAuthorName
        self.artworkAuthorName = artworkAuthorName
        self.likesCount = likesCount
    }
    
    // MARK: - Fields
    @State private var isLiked: Bool = false
    @State private var likesCount: Int
    private var title: String
    private var location: String
    private var description: String
    private var date: String
    private var postAuthorName: String
    private var artworkAuthorName: String
    
    // MARK: - Subviews
    private var artworkImage: some View {
        RoundedRectangle(cornerRadius: Const.imageCornerRadius)
            .fill(Const.placeholderColor)
            .frame(maxWidth: .infinity)
            .frame(height: Const.imageHeight)
            .overlay {
                Icons.photo
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(Color.secondaryColor)
            }
    }
    
    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.InstrumentBold20)
                .foregroundStyle(.black)
            
            Spacer(minLength: Metrics.oneAndHalfModule)
            
            HStack(spacing: Metrics.module) {
                Text(String(likesCount))
                    .font(.InstrumentMedium13)
                    .foregroundStyle(.black)
                
                if isLiked {
                    Icons.filledHeart
                        .onTapGesture {
                            toggleLike()
                        }
                } else {
                    Icons.heart
                        .onTapGesture {
                            toggleLike()
                        }
                }
                
            }
        }
    }
    
    private var metaRow: some View {
        HStack(alignment: .center) {
            Label {
                Text(location)
                    .font(.InstrumentRegular13)
            } icon: {
                Icons.location
            }
            .foregroundStyle(Color.secondaryColor)
            
            Spacer(minLength: Metrics.oneAndHalfModule)
            
            Text(date)
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
    }
    
    private var descriptionText: some View {
        Text(description)
            .font(.InstrumentRegular13)
            .foregroundStyle(Color.secondaryColor)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, Metrics.module)
    }
    
    private func personSection(title: String, titleFont: Font, name: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(Color.accentRed)
            
            MiniProfileView(name: name)
        }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                artworkImage
                
                VStack(alignment: .leading, spacing: Metrics.threeQuartersModule) {
                    titleRow
                    metaRow
                }
                
                descriptionText
                
                VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                    personSection(
                        title: "Author",
                        titleFont: .InstrumentBold13,
                        name: artworkAuthorName
                    )
                    
                    personSection(
                        title: "Posted by",
                        titleFont: .InstrumentRegular13,
                        name: postAuthorName
                    )
                }
            }
            .padding(.horizontal, Metrics.tripleModule)
            .padding(.top, Metrics.tripleModule)
            .padding(.bottom, Metrics.tripleModule)
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

//
//#Preview {
//    ArtMediumCardView()
//}
