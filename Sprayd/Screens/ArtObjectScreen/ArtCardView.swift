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
        static let cardTopPadding: CGFloat = 5

        static let imageCornerRadius: CGFloat = 30

        static let contentSpacing: CGFloat = 18
        static let sectionSpacing: CGFloat = 10
        static let peopleBlockSpacing: CGFloat = 14

        static let titleToMetaSpacing: CGFloat = 6
        static let descriptionTopSpacing: CGFloat = 8

        static let heartIconSize: CGFloat = 18
        static let locationIconSize: CGFloat = 18

        static let heartIcon = "heartIcon"
        static let filledHeartIcon = "filledHeartIcon"
        static let locationIcon = "locationIcon"
    }

    // MARK: - Fields
    var viewModel: ArtObjectViewModel

    private var currentHeartIcon: String {
        viewModel.isLiked ? Const.filledHeartIcon : Const.heartIcon
    }

    private func photoPage(_ photo: ArtObjectViewModel.PhotoItem, side: CGFloat) -> some View {
        Image(photo.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: side, height: side)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.openPhotoPreview(at: photo.index)
            }
            .tag(photo.index)
    }

    // MARK: - Subviews
    private var photoPager: some View {
        @Bindable var vm = viewModel
        return GeometryReader { geo in
            let side = geo.size.width
            TabView(selection: $vm.selectedPhotoIndex) {
                SwiftUI.ForEach(viewModel.photoItems) { photo in
                    photoPage(photo, side: side)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: Const.imageCornerRadius))
    }

    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(viewModel.name)
                .font(Font.InstrumentBold20)
                .foregroundStyle(.black)

            Spacer(minLength: 12)

            HStack(spacing: 8) {
                Text(String(viewModel.likesCount))
                    .font(Font.InstrumentMedium13)
                    .foregroundStyle(.black)

                Image(currentHeartIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Const.heartIconSize, height: Const.heartIconSize)
                    .foregroundStyle(Color.accentRed)
                    .onTapGesture {
                        viewModel.toggleLike()
                    }
            }
        }
    }

    private var metaRow: some View {
        HStack(alignment: .center) {
            Label {
                Text(viewModel.location)
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

            Text(viewModel.dateText)
                .font(Font.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
    }

    private var descriptionText: some View {
        Text(viewModel.itemDescription)
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
        VStack(alignment: .leading, spacing: Const.contentSpacing) {
            photoPager

            VStack(alignment: .leading, spacing: Const.titleToMetaSpacing) {
                titleRow
                metaRow
            }

            descriptionText

            VStack(alignment: .leading, spacing: Const.peopleBlockSpacing) {
                personSection(
                    title: "Author",
                    titleFont: Font.InstrumentBold13,
                    name: viewModel.author
                )

                personSection(
                    title: "Posted by",
                    titleFont: Font.InstrumentBold13,
                    name: viewModel.postedBy
                )
            }
        }
        .padding(.horizontal, Const.cardHorizontalPadding)
        .padding(.top, Const.cardTopPadding)
        .padding(.bottom, Const.cardTopPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ArtCardView(viewModel: .sample)
}
