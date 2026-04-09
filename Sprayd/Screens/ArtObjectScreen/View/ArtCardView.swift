//
//  ArtCardView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import SwiftUI
import Foundation

struct ArtCardView: View {
    // MARK: - Constants
    private enum Const {
        static let imageCornerRadius: CGFloat = 30
    }

    // MARK: - Fields
    var viewModel: ArtObjectViewModel
    let onAuthorTap: () -> Void
    let onPostedByTap: () -> Void

    // MARK: - Subviews
    @ViewBuilder
    private func photoPage(index: Int, side: CGFloat) -> some View {
        let source = viewModel.photoImageNames[index]

        Group {
            if let url = URL(string: source), let scheme = url.scheme, scheme.hasPrefix("http") {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: side, height: side)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.secondaryColor)
                            .padding(Metrics.tripleModule)
                    }
                }
            } else {
                Image(source)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: side, height: side)
        .clipped()
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.openPhotoPreview(at: index)
        }
        .tag(index)
    }

    private func photoPager(selection: Binding<Int>) -> some View {
        GeometryReader { geo in
            let side = geo.size.width
            TabView(selection: selection) {
                ForEach(viewModel.photoImageNames.indices, id: \.self) { index in
                    photoPage(index: index, side: side)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: viewModel.photoImageNames.count > 1 ? .automatic : .never))
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: Const.imageCornerRadius))
    }

    private var titleRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(viewModel.name)
                .font(Font.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)

            Spacer(minLength: Metrics.oneAndHalfModule)

            HStack(spacing: Metrics.module) {
                Text(String(viewModel.likesCount))
                    .font(Font.InstrumentMedium13)
                    .foregroundStyle(Color.appPrimaryText)

                if viewModel.isLiked {
                    Icons.filledHeart
                } else {
                    Icons.heart
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
                Icons.location
            }
            .foregroundStyle(Color.secondaryColor)

            Spacer(minLength: Metrics.oneAndHalfModule)

            Text(viewModel.dateText)
                .font(Font.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
        }
    }

    private var descriptionText: some View {
        Text(viewModel.itemDescription)
            .font(Font.InstrumentRegular13)
            .foregroundStyle(Color.secondaryColor)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, Metrics.module)
    }

    private func personSection(
        title: String,
        titleFont: Font,
        name: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(Color.accentRed)

            Button(action: action) {
                MiniProfileView(name: name)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Body
    var body: some View {
        @Bindable var vm = viewModel
        VStack(alignment: .leading, spacing: Metrics.doubleModule) {
            photoPager(selection: $vm.selectedPhotoIndex)

            VStack(alignment: .leading, spacing: Metrics.threeQuartersModule) {
                titleRow
                metaRow
            }

            descriptionText

            VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
                personSection(
                    title: "Author",
                    titleFont: Font.InstrumentMedium13,
                    name: viewModel.author,
                    action: onAuthorTap
                )

                personSection(
                    title: "Posted by",
                    titleFont: Font.InstrumentRegular13,
                    name: viewModel.postedBy,
                    action: onPostedByTap
                )
            }
        }
        .padding(.horizontal, Metrics.tripleModule)
        .padding(.top, Metrics.threeQuartersModule)
        .padding(.bottom, Metrics.threeQuartersModule)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ArtCardView(
        viewModel: .sample,
        onAuthorTap: {},
        onPostedByTap: {}
    )
}
