//
//  Metrics.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import SwiftUI

struct Metrics {
    /// 4
    static let halfModule: CGFloat = 4
    
    /// 6
    static var threeQuartersModule: CGFloat { halfModule * 1.5 }
    
    /// 8
    static var module: CGFloat { halfModule * 2 }
    
    /// 12
    static var oneAndHalfModule: CGFloat { module * 1.5 }
    
    /// 16
    static var doubleModule: CGFloat { module * 2 }
    
    /// 20
    static var twoAndHalfModule: CGFloat { module * 2.5 }
    
    /// 24
    static var tripleModule: CGFloat { module * 3 }
    
    /// 32
    static var quadrupleModule: CGFloat { doubleModule * 2 }

    /// 64
    static var eightTimesModule: CGFloat { module * 8 }
    
    /// 80
    static var tenTimesModule: CGFloat { module * 10 }
}

enum Motion {
    enum Duration {
        static let instant: TimeInterval = 0.16
        static let quick: TimeInterval = 0.2
        static let standard: TimeInterval = 0.35
        static let extended: TimeInterval = 0.45
        static let searchDebounce: UInt64 = 300_000_000
    }

    enum Spring {
        static let quickResponse: Double = 0.28
        static let standardResponse: Double = 0.42
        static let bouncyResponse: Double = 0.34
        static let tightDamping: Double = 0.82
        static let standardDamping: Double = 0.86
        static let bouncyDamping: Double = 0.62
        static let blendDuration: Double = 0
    }

    enum Scale {
        static let identity: CGFloat = 1
        static let pressed: CGFloat = 0.96
        static let subtlePressed: CGFloat = 0.985
        static let favoriteSelected: CGFloat = 1.16
        static let floatingLifted: CGFloat = 1.04
    }

    enum Offset {
        static let entranceY: CGFloat = 18
        static let titleEntranceY: CGFloat = 24
        static let buttonEntranceY: CGFloat = 16
    }

    enum Opacity {
        static let visible: Double = 1
        static let hidden: Double = 0
        static let searchDim: Double = 0.18
    }

    enum Delay {
        static let none: Double = 0
        static let title: Double = 0.08
        static let subtitle: Double = 0.16
        static let button: Double = 0.28
        static let section: Double = 0.04
    }

    static let instant = Animation.easeOut(duration: Duration.instant)
    static let quick = Animation.easeOut(duration: Duration.quick)
    static let standard = Animation.easeInOut(duration: Duration.standard)
    static let extended = Animation.easeInOut(duration: Duration.extended)
    static let press = Animation.spring(
        response: Spring.quickResponse,
        dampingFraction: Spring.tightDamping,
        blendDuration: Spring.blendDuration
    )
    static let softSpring = Animation.spring(
        response: Spring.standardResponse,
        dampingFraction: Spring.standardDamping,
        blendDuration: Spring.blendDuration
    )
    static let favorite = Animation.spring(
        response: Spring.bouncyResponse,
        dampingFraction: Spring.bouncyDamping,
        blendDuration: Spring.blendDuration
    )
}

struct PressScaleButtonStyle: ButtonStyle {
    private let pressedScale: CGFloat

    init(pressedScale: CGFloat = Motion.Scale.pressed) {
        self.pressedScale = pressedScale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : Motion.Scale.identity)
            .animation(Motion.press, value: configuration.isPressed)
    }
}

struct EntranceModifier: ViewModifier {
    let isVisible: Bool
    let delay: Double
    let yOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? Motion.Opacity.visible : Motion.Opacity.hidden)
            .offset(y: isVisible ? 0 : yOffset)
            .animation(Motion.softSpring.delay(delay), value: isVisible)
    }
}

extension View {
    func pressScale(_ pressedScale: CGFloat = Motion.Scale.pressed) -> some View {
        buttonStyle(PressScaleButtonStyle(pressedScale: pressedScale))
    }

    func entrance(
        isVisible: Bool,
        delay: Double = Motion.Delay.none,
        yOffset: CGFloat = Motion.Offset.entranceY
    ) -> some View {
        modifier(
            EntranceModifier(
                isVisible: isVisible,
                delay: delay,
                yOffset: yOffset
            )
        )
    }
}
