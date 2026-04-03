//
//  PhotoView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import SwiftUI

struct PhotoView: View {
    @Binding var selectedPhotoIndex: Int
    let photoImageNames: [String]

    private func photoPage(
        _ photo: ArtObjectViewModel.PhotoItem,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        Image(photo.imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(20)
            .frame(width: width, height: height)
            .tag(photo.index)
    }

    var body: some View {
        GeometryReader { geo in
            let safeWidth = max(1, geo.size.width - 40)
            let safeHeight = max(1, geo.size.height)
            let tabHeight = max(120, safeHeight * 0.58)
            let photoItems = photoImageNames.enumerated().map {
                ArtObjectViewModel.PhotoItem(index: $0.offset, imageName: $0.element)
            }

            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack {
                    Spacer(minLength: 0)

                    TabView(selection: $selectedPhotoIndex) {
                        SwiftUI.ForEach(photoItems) { photo in
                            photoPage(photo, width: safeWidth, height: tabHeight)
                        }
                    }
                    .frame(height: tabHeight)
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .offset(y: -safeHeight * 0.06)

                    Spacer(minLength: 0)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PhotoView(
            selectedPhotoIndex: .constant(0),
            photoImageNames: ArtObjectViewModel.sample.photoImageNames
        )
    }
}
