//
//  PhotoPagerView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct PhotoPagerView: View {
    let images = ["art", "bird", "cube"]

    var body: some View {
        GeometryReader { outerGeo in
            let width = outerGeo.size.width - 40
            let height = width * 1.2

            TabView {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay(alignment: .topLeading) {
                            Text("02.03.2024")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .cornerRadius(10)
                                .background(Color.accentRed)
                                .clipShape(Capsule())
                                .padding(20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: height)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
        .frame(height: (UIScreen.main.bounds.width - 40) * 1.2)
    }
}

#Preview {
    PhotoPagerView()
}
