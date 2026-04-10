//
//  PhotoView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import SwiftUI
import Foundation

struct PhotoView: View {
    @Binding var selectedPhotoIndex: Int
    let photoImageNames: [String]

    @ViewBuilder
    private func photoPage(index: Int, width: CGFloat, height: CGFloat) -> some View {
        let source = photoImageNames[index]

        Group {
            if let url = RemoteAssetURL.normalizedURL(from: source) {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: width, height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.secondaryColor)
                    }
                }
            } else {
                Image(source)
                    .resizable()
                    .scaledToFit()
            }
        }
        .cornerRadius(20)
        .frame(width: width, height: height)
        .clipped()
        .tag(index)
    }

    var body: some View {
        GeometryReader { geo in
            let safeWidth = max(1, geo.size.width - 40)
            let safeHeight = max(1, geo.size.height)
            let tabHeight = max(120, safeHeight * 0.58)

            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack {
                    Spacer()
                    TabView(selection: $selectedPhotoIndex) {
                        ForEach(photoImageNames.indices, id: \.self) { index in
                            photoPage(index: index, width: safeWidth, height: tabHeight)
                        }
                    }
                    .frame(height: tabHeight)
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .offset(y: -safeHeight * 0.06)

                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
