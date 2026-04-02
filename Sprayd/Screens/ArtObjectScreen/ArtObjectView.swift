//
//  ArtObjectView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct ArtObjectView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea(edges: .all)
            ScrollView {
                Spacer(minLength: 20)
                PhotoPagerView()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name of Art")
                        .font(Font.InstrumentBold22)
                    Text(
                        "73 is the 21-st prime number. Its mirror, 37, is the 12-th, and its mirror, 21, " +
                        "is the product of multiplying, hang on to your hats, 7 and 3."
                    )
                        .foregroundStyle(Color(.secondaryLabel))
                        .font(Font.InstrumentMedium16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ArtObjectView()
}
