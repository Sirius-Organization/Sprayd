//
//  ArtObjectPhotoPreviewView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 02.04.2026.
//

import SwiftUI

struct ArtObjectPhotoPreviewView: View {
    @Binding var selectedPhotoIndex: Int

    var body: some View {
        GeometryReader { geo in
            let safeWidth = max(1, geo.size.width - 40)
            let safeHeight = max(1, geo.size.height)
            let tabHeight = max(120, safeHeight * 0.58)

            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack {
                    Spacer(minLength: 0)
                    TabView(selection: $selectedPhotoIndex) {
                        ForEach(ArtObjectViewModel.photoItems) { photo in
                            Image(photo.imageName)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width: safeWidth, height: tabHeight)
                                .tag(photo.index)
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
        ArtObjectPhotoPreviewView(selectedPhotoIndex: .constant(0))
    }
}
