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
    
    // MARK: - Fields
    let item: ArtItem
    
    // MARK: - Subviews
    private func artworkImage(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: Const.imageCornerRadius)
            .fill(Const.placeholderColor)
            .frame(width: width)
            .frame(height: Const.imageHeight)
            .overlay {
                artworkImageContent
                    .frame(width: width, height: Const.imageHeight)
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Const.imageCornerRadius))
    }

    @ViewBuilder
    private var artworkImageContent: some View {
        CachedAsyncImage(url: item.primaryImageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .empty, .failure:
                RoundedRectangle(cornerRadius: Const.imageCornerRadius)
                    .fill(Color.clear)
                    .overlay {
                        Icons.photo
                            .font(.system(size: 34, weight: .regular))
                            .foregroundStyle(Color.secondaryColor)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var titleRow: some View {
        @Bindable var item = item

        return HStack(alignment: .firstTextBaseline) {
            Text(item.name)
                .font(.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)
            
            Spacer(minLength: Metrics.oneAndHalfModule)
            
            Button {
                item.isFavorite.toggle()
            } label: {
                if item.isFavorite {
                    Icons.filledHeart
                } else {
                    Icons.heart
                }
            }
            .buttonStyle(.plain)
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

    private func contentWidth(for availableWidth: CGFloat) -> CGFloat {
        max(availableWidth - (Metrics.tripleModule * 2), 0)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            let width = contentWidth(for: geometry.size.width)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    artworkImage(width: width)
                    
                    VStack(alignment: .leading, spacing: Metrics.threeQuartersModule) {
                        titleRow
                        metaRow
                    }
                    .frame(width: width, alignment: .leading)
                    
                    descriptionText
                        .frame(width: width, alignment: .leading)
                    
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
                    .frame(width: width, alignment: .leading)
                }
                .padding(.horizontal, Metrics.tripleModule)
                .padding(.top, Metrics.tripleModule)
                .padding(.bottom, Metrics.tripleModule)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
