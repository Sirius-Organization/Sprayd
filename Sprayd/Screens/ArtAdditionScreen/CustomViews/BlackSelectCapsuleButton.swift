//
//  BlackSelectCapsuleButton.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct BlackSelectCapsuleButton: View {
    // MARK: - Const
    private enum Const {
        // UI Constraint properties
        static let spacing: CGFloat = 10
        static let horizontalPadding: CGFloat = 10
        static let height: CGFloat = 30

        // Strings
        
        // Fonts
        static let textFont: Font = .InstrumentMedium13
        
        // Icons
        // Colors
    }
    let title: String
    let iconName: String?
    let action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Const.spacing) {
                Text(title)
                    .font(Const.textFont)
                    .foregroundStyle(Color.white)
                
                if let iconName {
                    Image(iconName)
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.horizontal, Const.horizontalPadding)
            .frame(height: Const.height)
            .background(Color.black)
            .clipShape(Capsule())
        }
    }
}

//#Preview {
//    BlackSelectCapsuleButton(title: "Title", iconName: "rightArrowIcon")
//}
