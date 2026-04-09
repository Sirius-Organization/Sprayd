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

    }

    // MARK: - Fields
    let onSignInTapped: () -> Void
    let onCreateAccountTapped: () -> Void
    let onProceedWithoutAccountTapped: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()

                Text("Sprayd")
                    .font(.ClimateCrisis52)
                    .foregroundStyle(Color.appPrimaryText)
                    .padding(.top, Const.titleTopInset)

                Spacer()
                    .frame(maxHeight: Metrics.quadrupleModule)

                authSection

                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Text("or")
                        .font(.InstrumentRegular16)
                        .foregroundStyle(Color.appPrimaryText.opacity(0.5))
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                proceedButton
                    .padding(.bottom, Metrics.quadrupleModule)
            }
            .padding(.horizontal, Metrics.tripleModule)
        }
    }

    // MARK: - Subviews
    private var authSection: some View {
        VStack(spacing: Metrics.doubleModule) {
            signInButton

            VStack(spacing: Metrics.halfModule) {
                Text("Don't have an account?")
                    .font(.InstrumentRegular16)
                    .foregroundStyle(Color.appPrimaryText)

                Button(action: onCreateAccountTapped) {
                    Text("Create an account")
                        .font(.InstrumentBold17)
                        .foregroundStyle(Color.appPrimaryText)
                }
            }
        }
    }

    private var signInButton: some View {
        Button(action: onSignInTapped) {
            HStack {
                Spacer()

                Text("Sign in")
                    .font(.InstrumentMedium18)
                    .foregroundStyle(Color.appContrastForeground)

                Spacer()

                Image(systemName: "person")
                    .font(.system(size: Const.personIconSize, weight: .medium))
                    .foregroundStyle(Color.appContrastForeground)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(Color.appContrastBackground)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .padding(.horizontal, Metrics.tripleModule)
    }

    private var proceedButton: some View {
        Button(action: onProceedWithoutAccountTapped) {
            HStack {
                Spacer()

                Text("Proceed without an account")
                    .font(.InstrumentMedium18)
                    .foregroundStyle(Color.appContrastForeground)

                Spacer()

                Icons.chevronRight
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appContrastForeground)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(Color.appContrastBackground)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
#Preview {
    ChooseAccountView(
        onSignInTapped: {},
        onCreateAccountTapped: {},
        onProceedWithoutAccountTapped: {}
    )
}
