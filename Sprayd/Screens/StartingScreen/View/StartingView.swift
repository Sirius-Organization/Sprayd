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
    }

    // MARK: - Subviews
    private var titleSection: some View {
        VStack(spacing: Metrics.doubleModule) {
            Text("Sprayd")
                .font(.ClimateCrisis52)
                .foregroundStyle(Color.appPrimaryText)

            Text("Discover new street art and\npost your own!")
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.appPrimaryText)
                .multilineTextAlignment(.center)
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
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
//#Preview {
//    OnboardingView()
//}
