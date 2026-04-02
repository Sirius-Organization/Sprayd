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
        TabView {
            ForEach(images, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay(alignment: .topLeading) {
                        dateLabel
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
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
