//
//  PhotoPagerView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct PhotoPagerView: View {
    @Binding var selectedPhotoIndex: Int
    let onPhotoTap: (String) -> Void

    private let cornerRadius: CGFloat = 30
    private let dateLabelText = "02.03.2024"

    var body: some View {
        GeometryReader { outerGeo in
            let width = max(1, outerGeo.size.width - 40)
            let photoHeight = width

            VStack(spacing: 0) {
                TabView(selection: $selectedPhotoIndex) {
                    ForEach(ArtObjectViewModel.photoItems) { photo in
                        photoPage(photo.imageName, width: width, height: photoHeight)
                            .tag(photo.index)
                    }
                }
                .frame(height: photoHeight)
                .tabViewStyle(.page(indexDisplayMode: .automatic))

                Spacer(minLength: 0)
            }
        }
        .frame(height: max(1, UIScreen.main.bounds.width - 40))
    }

    private func photoPage(_ imageName: String, width: CGFloat, height: CGFloat) -> some View {
        PhotoPage(
            imageName: imageName,
            width: width,
            height: height,
            cornerRadius: cornerRadius,
            dateLabel: dateLabel,
            onTap: { onPhotoTap(imageName) }
        )
    }

    private var dateLabel: some View {
        Text(dateLabelText)
            .foregroundColor(.white)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .cornerRadius(10)
            .background(Color.accentRed)
            .clipShape(Capsule())
            .padding(20)
    }
}

private struct PhotoPage<DateLabel: View>: View {
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let dateLabel: DateLabel
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .onTapGesture(perform: onTap)

            dateLabel
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    PhotoPagerView(selectedPhotoIndex: .constant(0), onPhotoTap: { _ in })
}
