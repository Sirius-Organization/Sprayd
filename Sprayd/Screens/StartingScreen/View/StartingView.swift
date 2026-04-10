//
//  StartingView.swift
//  Sprayd
//
//  Created by loxxy on 05.04.2026.
//

import SwiftUI

struct StartingView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28
        static let titleTopInset: CGFloat = 48

    }

    // MARK: - Fields
    let onGetStartedTapped: () -> Void
    @State private var isContentVisible = false

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()

            VStack {
                Spacer()
                titleSection
                Spacer()
                getStartedButton
                    .padding(.bottom, Metrics.quadrupleModule)
            }
            .padding(.horizontal, Metrics.tripleModule)
        }
        .onAppear {
            isContentVisible = true
        }
    }

    // MARK: - Subviews
    private var titleSection: some View {
        VStack(spacing: Metrics.doubleModule) {
            Text("Sprayd")
                .font(.ClimateCrisis52)
                .foregroundStyle(Color.appPrimaryText)
                .entrance(
                    isVisible: isContentVisible,
                    delay: Motion.Delay.title,
                    yOffset: Motion.Offset.titleEntranceY
                )

            Text("Discover new street art and\npost your own!")
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.appPrimaryText)
                .multilineTextAlignment(.center)
                .entrance(
                    isVisible: isContentVisible,
                    delay: Motion.Delay.subtitle,
                    yOffset: Motion.Offset.entranceY
                )
        }
        .padding(.top, Const.titleTopInset)
    }

    private var getStartedButton: some View {
        Button(action: onGetStartedTapped) {
            Text("Get started")
                .font(.InstrumentMedium18)
                .foregroundStyle(Color.appContrastForeground)
                .frame(maxWidth: .infinity)
                .frame(height: Const.buttonHeight)
                .background(Color.appContrastBackground)
                .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .pressScale()
        .padding(.horizontal, Metrics.tripleModule)
        .entrance(
            isVisible: isContentVisible,
            delay: Motion.Delay.button,
            yOffset: Motion.Offset.buttonEntranceY
        )
    }
}

// MARK: - Preview
//#Preview {
//    OnboardingView()
//}
