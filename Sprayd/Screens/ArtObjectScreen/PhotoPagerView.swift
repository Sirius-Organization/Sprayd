//
//  PhotoPagerView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct PhotoPagerView: View {
    let images = ["art", "bird", "cube"]
    private let cornerRadius: CGFloat = 30
    private let dateLabelText = "02.03.2024"

    var body: some View {
        GeometryReader { outerGeo in
            let width = outerGeo.size.width - 40
            let photoHeight = width

            VStack(spacing: 0) {
                TabView {
                    ForEach(images, id: \.self) { imageName in
                        ZStack(alignment: .topLeading) {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: photoHeight)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                            
                            dateLabel
                        }
                        .frame(width: width, height: photoHeight)
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

#Preview {
    PhotoPagerView()
}
