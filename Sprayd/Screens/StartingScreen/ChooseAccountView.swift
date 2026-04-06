//
//  ChooseAccountView.swift
//  Sprayd
//
//  Created by loxxy on 05.04.2026.
//

import SwiftUI

struct ChooseAccountView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28
        static let personIconSize: CGFloat = 20
        static let titleTopInset: CGFloat = 200

        static let titleText = "Sprayd"
        static let signInText = "Sign in"
        static let noAccountText = "Don't have an account?"
        static let createAccountText = "Create an account"
        static let orText = "or"
        static let proceedText = "Proceed without an account"
    }

    // MARK: - Fields
    let onSignInTapped: () -> Void
    let onCreateAccountTapped: () -> Void
    let onProceedWithoutAccountTapped: () -> Void

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text(Const.titleText)
                .font(.ClimateCrisis52)
                .foregroundStyle(.black)
                .padding(.top, Const.titleTopInset)

            Spacer()
                .frame(maxHeight: Metrics.quadrupleModule)

            authSection

            VStack(spacing: 0) {
                Spacer(minLength: 0)
                Text(Const.orText)
                    .font(.InstrumentRegular16)
                    .foregroundStyle(.black.opacity(0.5))
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            proceedButton
                .padding(.bottom, Metrics.quadrupleModule)
        }
        .padding(.horizontal, Metrics.tripleModule)
    }

    // MARK: - Subviews
    private var authSection: some View {
        VStack(spacing: Metrics.doubleModule) {
            signInButton

            VStack(spacing: Metrics.halfModule) {
                Text(Const.noAccountText)
                    .font(.InstrumentRegular16)
                    .foregroundStyle(.black)

                Button(action: onCreateAccountTapped) {
                    Text(Const.createAccountText)
                        .font(.InstrumentBold17)
                        .foregroundStyle(.black)
                }
            }
        }
    }

    private var signInButton: some View {
        Button(action: onSignInTapped) {
            HStack {
                Spacer()

                Text(Const.signInText)
                    .font(.InstrumentMedium18)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "person")
                    .font(.system(size: Const.personIconSize, weight: .medium))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .padding(.horizontal, Metrics.tripleModule)
    }

    private var proceedButton: some View {
        Button(action: onProceedWithoutAccountTapped) {
            HStack {
                Spacer()

                Text(Const.proceedText)
                    .font(.InstrumentMedium18)
                    .foregroundStyle(.white)

                Spacer()

                Icons.chevronRight
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        RadialGradient(
            gradient: Gradient(colors: [.gradientCenterColor, .gradientEdgeColor]),
            center: .center,
            startRadius: 0,
            endRadius: 400
        )
        .ignoresSafeArea()

        ChooseAccountView(
            onSignInTapped: {},
            onCreateAccountTapped: {},
            onProceedWithoutAccountTapped: {}
        )
    }
}
