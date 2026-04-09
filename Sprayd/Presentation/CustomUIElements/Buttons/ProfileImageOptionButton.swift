//
//  ProfileImageOptionButton.swift
//  Sprayd
//
//  Created by loxxy on 07.04.2026.
//

import SwiftUI

struct ProfileImageOptionButton: View {
    // MARK: - Fields
    private let title: String
    private let icon: AnyView
    private let action: () -> Void
    
    // MARK: - Lifecycle
    init<Icon: View>(
        title: String,
        icon: Icon,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = AnyView(icon)
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: Metrics.module) {
                icon
                    .foregroundStyle(Color.accentRed)
                
                Text(title)
                    .font(.InstrumentMedium16)
                    .foregroundStyle(Color.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, Metrics.oneAndHalfModule)
            .padding(.vertical, Metrics.module)
        }
        .buttonStyle(.plain)
    }
}
