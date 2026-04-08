//
//  SearchBarView.swift
//  Sprayd
//

import SwiftUI

struct SearchBarView: View {
    private enum Const {
        static let height: CGFloat = 42
        static let cornerRadius: CGFloat = 10
        static let iconSize: CGFloat = 14
        static let borderLineWidth: CGFloat = 1
        static let borderOpacity: CGFloat = 0.3
    }

    private let placeholder: String
    private let text: Binding<String>?
    private let actionTitle: String?
    private let isActionDisabled: Bool
    private let textInputAutocapitalization: TextInputAutocapitalization
    private let onSubmit: (() -> Void)?
    private let onTextChange: ((String) -> Void)?
    private let onFocusChange: ((Bool) -> Void)?

    @FocusState private var isFocused: Bool

    init(placeholder: String) {
        self.placeholder = placeholder
        self.text = nil
        self.actionTitle = nil
        self.isActionDisabled = false
        self.textInputAutocapitalization = .sentences
        self.onSubmit = nil
        self.onTextChange = nil
        self.onFocusChange = nil
    }

    init(
        placeholder: String,
        text: Binding<String>,
        actionTitle: String? = nil,
        isActionDisabled: Bool = false,
        textInputAutocapitalization: TextInputAutocapitalization = .sentences,
        onSubmit: (() -> Void)? = nil,
        onTextChange: ((String) -> Void)? = nil,
        onFocusChange: ((Bool) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.text = text
        self.actionTitle = actionTitle
        self.isActionDisabled = isActionDisabled
        self.textInputAutocapitalization = textInputAutocapitalization
        self.onSubmit = onSubmit
        self.onTextChange = onTextChange
        self.onFocusChange = onFocusChange
    }

    var body: some View {
        HStack(spacing: Metrics.module) {
            Icons.magnifyingGlass
                .font(.system(size: Const.iconSize, weight: .medium))

            if let text {
                TextField(placeholder, text: text)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.black)
                    .textInputAutocapitalization(textInputAutocapitalization)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit?()
                    }
                    .onChange(of: text.wrappedValue) { _, newValue in
                        onTextChange?(newValue)
                    }
            } else {
                Text(placeholder)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(.gray)
            }

            Spacer(minLength: Metrics.halfModule)

            if let actionTitle {
                Button(actionTitle) {
                    onSubmit?()
                }
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.black)
                .disabled(isActionDisabled)
            }
        }
        .padding(.horizontal, Metrics.oneAndHalfModule)
        .frame(height: Const.height)
        .background(
            RoundedRectangle(cornerRadius: Const.cornerRadius, style: .continuous)
                .fill(Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Const.cornerRadius, style: .continuous)
                .stroke(Color.black.opacity(Const.borderOpacity), lineWidth: Const.borderLineWidth)
        )
        .onChange(of: isFocused) { _, newValue in
            onFocusChange?(newValue)
        }
    }
}

#Preview {
    VStack(spacing: Metrics.module) {
        SearchBarView(placeholder: "Search for an art object")
        SearchBarView(
            placeholder: "Search author",
            text: .constant("Ana"),
            actionTitle: "Search"
        )
    }
    .padding()
    .background(Color.appBackground)
}
