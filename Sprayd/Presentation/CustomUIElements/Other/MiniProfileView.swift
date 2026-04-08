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
    }
    
    // MARK: - Fields
    let name: String

    // MARK: - Body
    var body: some View {
        HStack(spacing: Metrics.oneAndHalfModule) {
            Icons.personCircle
                .frame(width: Const.avatarSize, height: Const.avatarSize)
                .foregroundStyle(Color.secondaryColor.opacity(0.7))
            
            Text(name)
                .font(.InstrumentRegular13)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    MiniProfileView(name: "Ana Markov")
}
