//
//  AddButton.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct AddButton: View {
    // MARK: - Constants
    private enum Const {
        // UI constraint properties
        static let buttonSize: CGFloat = 70
        static let shadowRadius: CGFloat = 5
        
        // Fonts
        static let textFont: Font = .system(size: 24, weight: .medium)
    }
    
    // MARK: - Body
    var body: some View {
        Button {
            // action
        } label: {
            Icons.plus
                .font(Const.textFont)
                .foregroundColor(.white)
                .frame(width: Const.buttonSize, height: Const.buttonSize)
                .background(Color.accentRed)
                .clipShape(Circle())
                .shadow(radius: Const.shadowRadius)
        }
        .buttonStyle(.plain)
    
    }
}

#Preview {
    AddButton()
}
