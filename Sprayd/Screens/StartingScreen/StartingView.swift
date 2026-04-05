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
        static let gradientRadius: CGFloat = 400

        static let titleText = "Sprayd"
        static let subtitleText = "Discover new street art and\npost your own!"
        static let buttonText = "Get started"
    }

    // MARK: - Fields
    let onGetStartedTapped: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundGradient
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
    private var backgroundGradient: some View {
        RadialGradient(
            gradient: Gradient(colors: [
                .gradientCenterColor,
                .gradientEdgeColor
            ]),
            center: .center,
            startRadius: 0,
            endRadius: Const.gradientRadius
        )
    }

    private var titleSection: some View {
        VStack(spacing: Metrics.doubleModule) {
            Text(Const.titleText)
                .font(.ClimateCrisis52)
                .foregroundStyle(.black)

            Text(Const.subtitleText)
                .font(.InstrumentMedium16)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
        }
    }

    private var getStartedButton: some View {
        Button(action: onGetStartedTapped) {
            Text(Const.buttonText)
                .font(.InstrumentMedium18)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Const.buttonHeight)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
#Preview {
    StartingView(onGetStartedTapped: {})
}
