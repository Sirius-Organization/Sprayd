//
//  Design.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI

extension Color {
    static let appBackground = Color(
        red: 232 / 255,
        green: 227 / 255,
        blue: 224 / 255
    )

    static let accentRed = Color(
        red: 255 / 255,
        green: 85 / 255,
        blue: 73 / 255
    )

    static let secondaryColor = Color(
        red: 107 / 255,
        green: 106 / 255,
        blue: 105 / 255
    )

    static let placeholderGrey = Color(
        red: 137 / 255,
        green: 137 / 255,
        blue: 137 / 255
    )
    
    static let gradientCenterColor = Color(red: 1, green: 0.53, blue: 0.28)
    
    static let gradientEdgeColor = Color(red: 1, green: 0.33, blue: 0.29)
}

extension RadialGradient {
    static let onboardingBackground = RadialGradient(
        gradient: Gradient(colors: [
            .gradientCenterColor,
            .gradientEdgeColor
        ]),
        center: .center,
        startRadius: 0,
        endRadius: 400
    )
}
