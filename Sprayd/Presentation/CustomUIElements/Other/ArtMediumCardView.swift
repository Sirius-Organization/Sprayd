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
        
        static let placeholderColor = Color.appMutedFill
    }
    
    // MARK: - Lifecycle
    init(item: ArtItem) {
        self.item = item
        _likesCount = State(initialValue: 0)
    }
    
    // MARK: - Fields
    @State private var isLiked: Bool = false
    @State private var likesCount: Int
    private let item: ArtItem
    
    // MARK: - Subviews
    private var artworkImage: some View {
        CachedAsyncImage(url: item.primaryImageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .empty, .failure:
                RoundedRectangle(cornerRadius: Const.imageCornerRadius)
                    .fill(Const.placeholderColor)
                    .overlay {
                        Icons.photo
                            .font(.system(size: 34, weight: .regular))
                            .foregroundStyle(Color.secondaryColor)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Const.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: Const.imageCornerRadius))
    }
    
    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(item.name)
                .font(.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)
            
            Spacer(minLength: Metrics.oneAndHalfModule)
            
            HStack(spacing: Metrics.module) {
                Text(String(likesCount))
                    .font(.InstrumentMedium13)
                    .foregroundStyle(Color.appPrimaryText)
                
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
                Text(item.location)
                    .font(.InstrumentRegular13)
            } icon: {
                Icons.location
            }
            .foregroundStyle(Color.secondaryColor)
            
            Spacer(minLength: Metrics.oneAndHalfModule)
            
            Text("01.01.25")
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
    }
    
    private var descriptionText: some View {
        Text(item.itemDescription)
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
                        name: item.author
                    )
                    
                    personSection(
                        title: "Posted by",
                        titleFont: .InstrumentRegular13,
                        name: "PostAuthor"
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
