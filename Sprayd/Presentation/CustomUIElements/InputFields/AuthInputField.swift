//
//  AuthInputField.swift
//  Sprayd
//
//  Created by loxxy on 06.04.2026.
//

import SwiftUI
import UIKit

enum ValidationState {
    case none
    case valid
    case invalid
}

struct AuthInputField: View {
    // MARK: - Constants
    private enum Const {
        static let fieldHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let labelHorizontalPadding: CGFloat = 8
        static let labelOffsetX: CGFloat = 8
        static let gapExtraWidth: CGFloat = 8
    }

    // MARK: - Fields
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isPasswordToggleable: Bool = false
    var validationState: ValidationState = .none
    var textContentType: UITextContentType? = nil

    @State private var isRevealed: Bool = false

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .topLeading) {
            TopGapRoundedRectangle(
                cornerRadius: Const.cornerRadius,
                gapStartX: Const.labelOffsetX + Metrics.module,
                gapWidth: titleWidth + (Const.labelHorizontalPadding * 2) + Const.gapExtraWidth
            )
                .stroke(Color.black.opacity(0.45), lineWidth: Const.borderWidth)
                .frame(height: Const.fieldHeight)

            HStack(spacing: Metrics.module) {
                field
                trailingIcons
            }
            .padding(.horizontal, Metrics.doubleModule)
            .frame(height: Const.fieldHeight, alignment: .center)

            Text(title)
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.black)
                .padding(.horizontal, Metrics.module)
                .offset(x: Const.labelOffsetX + Metrics.module, y: -Metrics.oneAndHalfModule)
        }
        .padding(.top, Metrics.oneAndHalfModule)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var field: some View {
        if isSecure && !isRevealed {
            SecureField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundStyle(Color.black.opacity(0.7))
            )
            .tint(Color.black.opacity(0.7))
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.InstrumentRegular18)
            .foregroundStyle(Color.black)
        } else {
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundStyle(Color.black.opacity(0.7))
            )
            .tint(Color.black.opacity(0.7))
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.InstrumentRegular18)
            .foregroundStyle(Color.black)
        }
    }

    @ViewBuilder
    private var trailingIcons: some View {
        HStack(spacing: Metrics.halfModule) {
            if validationState != .none {
                validationIndicator
            }

            if isPasswordToggleable {
                Button {
                    isRevealed.toggle()
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.black.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var validationIndicator: some View {
        switch validationState {
        case .valid:
            Icons.validationCheckmark
        case .invalid:
            Icons.validationXmark
        case .none:
            EmptyView()
        }
    }

    // MARK: - Utility
    private var titleWidth: CGFloat {
        let uiFont = UIFont(name: "InstrumentSans-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        return (title as NSString).size(withAttributes: [.font: uiFont]).width
    }
}

private struct TopGapRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    let gapStartX: CGFloat
    let gapWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        let radius = min(cornerRadius, min(rect.width, rect.height) / 2)
        let left = rect.minX
        let right = rect.maxX
        let top = rect.minY
        let bottom = rect.maxY

        let minGapStart = left + radius + 2
        let maxGapEnd = right - radius - 2
        let start = max(minGapStart, min(gapStartX, maxGapEnd))
        let end = max(start, min(start + gapWidth, maxGapEnd))

        var path = Path()

        path.move(to: CGPoint(x: left + radius, y: top))
        path.addLine(to: CGPoint(x: start, y: top))

        path.move(to: CGPoint(x: end, y: top))
        path.addLine(to: CGPoint(x: right - radius, y: top))
        path.addArc(
            center: CGPoint(x: right - radius, y: top + radius),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: right, y: bottom - radius))
        path.addArc(
            center: CGPoint(x: right - radius, y: bottom - radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: left + radius, y: bottom))
        path.addArc(
            center: CGPoint(x: left + radius, y: bottom - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: left, y: top + radius))
        path.addArc(
            center: CGPoint(x: left + radius, y: top + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        return path
    }
}
