//
//  Untitled.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct AddButton: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let imageName: String = "plus"
        
        // UI constraint properties
        static let buttonSize: CGFloat = 70
        static let shadowRadius: CGFloat = 5
        
        // Fonts
        static let textFont: Font = .system(size: 24, weight: .medium)
        
        // Colors
        static let buttonColor: Color = .accentRed
        static let foregroundColor: Color = .white
    }
    
    // MARK: - Fields
    
    // MARK: - Body
    var body: some View {
        Button {
            // action
        } label: {
            Image(systemName: Const.imageName)
                .font(Const.textFont)
                .foregroundColor(Const.foregroundColor)
                .frame(width: Const.buttonSize, height: Const.buttonSize)
                .background(Const.buttonColor)
                .clipShape(Circle())
                .shadow(radius: Const.shadowRadius)
        }
        .buttonStyle(.plain)
    
    }
}

#Preview {
    AddButton()
}
