//
//  MiniProfileView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct MiniProfileView: View {
    // MARK: - Constants
    private enum Const {
        static let avatarSize: CGFloat = 35
        static let avatarSpacing: CGFloat = 12
        
        static let personNameFont: Font = .custom("InstrumentSans-Regular", size: 13)
        static let avatarImageName: String = "person.crop.circle.fill"
    }
    
    // MARK: - Fields
    let name: String

    // MARK: - Body
    var body: some View {
        HStack(spacing: Const.avatarSpacing) {
            Image(systemName: Const.avatarImageName)
                .resizable()
                .scaledToFill()
                .frame(width: Const.avatarSize, height: Const.avatarSize)
                .foregroundStyle(Color.secondaryColor.opacity(0.7))
            
            Text(name)
                .font(Const.personNameFont)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    MiniProfileView(name: "Ana Markov")
}
