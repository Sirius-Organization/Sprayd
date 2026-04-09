//
//  CategoryCapsule.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct CategoryCapsule: View {
    // MARK: - Fields
    let title: String
    
    // MARK: - Body
    var body: some View {
        Text(title)
            .foregroundStyle(Color.appContrastForeground)
            .font(Font.InstrumentMedium13)
            .padding(Metrics.oneAndHalfModule)
            .frame(height: 40)
            .background(Color.accentRed)
            .clipShape(Capsule())
    }
}

#Preview {
    CategoryCapsule(title: "Sponsored by government")
}
