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
        let side = UIScreen.main.bounds.width - 40

        TabView {
            ForEach(images, id: \.self) { imageName in
                ZStack(alignment: .topLeading) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: side, height: side)
                        .clipped()

                    dateLabel
                }
                .frame(width: side, height: side)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: side)
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
