//
//  PhotoPagerView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct PhotoPagerView: View {
    private let images = ["art", "bird", "cube"]
    private let cornerRadius: CGFloat = 30
    private let dateLabelText = "02.03.2024"

    var body: some View {
        GeometryReader { outerGeo in
            let width = outerGeo.size.width - 40
            let photoHeight = width

            VStack(spacing: 0) {
                TabView {
                    ForEach(images.indices, id: \.self) { index in
                        PhotoPage(
                            imageName: images[index],
                            width: width,
                            height: photoHeight,
                            cornerRadius: cornerRadius,
                            dateLabel: dateLabel
                        )
                    }
                }
                .frame(height: photoHeight)
                .tabViewStyle(.page(indexDisplayMode: .automatic))

                Spacer(minLength: 0)
            }
        }
        .frame(height: UIScreen.main.bounds.width - 40)
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

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            dateLabel
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    PhotoPagerView()
}
