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
        TabView {
            ForEach(images, id: \.self) { imageName in
                GeometryReader { geo in
                    let side = geo.size.width - 40

                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: side, height: side)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width - 40)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }
}

#Preview {
    PhotoPagerView()
}
