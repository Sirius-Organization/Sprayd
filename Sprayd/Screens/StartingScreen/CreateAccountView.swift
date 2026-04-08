//
//  CreateAccountView.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI

struct CreateAccountView: View {
    // MARK: - Constants
    private enum Const {
        static let buttonHeight: CGFloat = 56
        static let buttonCornerRadius: CGFloat = 28

    }

    // MARK: - Fields
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""

    let onContinueTapped: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            RadialGradient.onboardingBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                Text("Create\naccount")
                    .font(.ClimateCrisis52)
                    .foregroundStyle(Color.black)

                AuthInputField(
                    title: "Username",
                    placeholder: "Enter username*",
                    text: $username,
                    textContentType: .username
                )

                AuthInputField(
                    title: "Email",
                    placeholder: "Enter email*",
                    text: $email,
                    textContentType: .emailAddress
                )

                AuthInputField(
                    title: "Password",
                    placeholder: "Enter password*",
                    text: $password,
                    isSecure: true,
                    textContentType: .oneTimeCode
                )

                AuthInputField(
                    title: "Password",
                    placeholder: "Repeat password*",
                    text: $repeatedPassword,
                    isSecure: true,
                    textContentType: .oneTimeCode
                )

                continueButton
                    .padding(.top, Metrics.doubleModule)

                Spacer()
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Subviews
    private var continueButton: some View {
        Button(action: onContinueTapped) {
            HStack {
                Text("Continue")
                    .font(.InstrumentMedium20)
                    .foregroundStyle(Color.white)

                Spacer()

                Icons.chevronRight
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, Metrics.tripleModule)
            .frame(height: Const.buttonHeight)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: Const.buttonCornerRadius))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Metrics.tripleModule)
    }
}

// MARK: - Preview
#Preview {
    CreateAccountView(onContinueTapped: {})
}
