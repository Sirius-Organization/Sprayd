//
//  Design.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI
import UIKit

extension Color {
    static let appBackground = Color("DesignBackground")
    static let appSurface = Color("DesignSurface")
    static let appMutedFill = Color("DesignMutedFill")
    static let appPrimaryText = Color("DesignPrimaryText")
    static let appSecondaryText = Color("DesignSecondaryText")
    static let appPlaceholderText = Color("DesignPlaceholderText")
    static let appContrastBackground = Color("DesignContrastBackground")
    static let appContrastForeground = Color("DesignContrastForeground")

    static let accentRed = Color("AccentColor")
    static let secondaryColor = Color.appSecondaryText
    static let placeholderGrey = Color.appPlaceholderText

    static let gradientCenterColor = Color("DesignGradientCenter")
    static let gradientEdgeColor = Color("DesignGradientEdge")
    static let validationSuccess = Color("DesignValidationSuccess")
    static let validationError = Color("DesignValidationError")
}

extension UIColor {
    static let appBackground = UIColor(named: "DesignBackground") ?? .systemBackground
    static let appSurface = UIColor(named: "DesignSurface") ?? .secondarySystemBackground
    static let appMutedFill = UIColor(named: "DesignMutedFill") ?? .tertiarySystemFill
    static let appPrimaryText = UIColor(named: "DesignPrimaryText") ?? .label
    static let appSecondaryText = UIColor(named: "DesignSecondaryText") ?? .secondaryLabel
    static let appContrastBackground = UIColor(named: "DesignContrastBackground") ?? .label
    static let appContrastForeground = UIColor(named: "DesignContrastForeground") ?? .systemBackground
    static let accentRed = UIColor(named: "AccentColor") ?? .systemRed
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
