//
//  OutlinedInputField.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import SwiftUI

struct OutlinedInputField: View {
    // MARK: - Const
    private enum Const {
        // UI Constraint properties
        static let cornerRadius: CGFloat = 11
        static let borderWidth: CGFloat = 1
        static let textFieldHeight: CGFloat = 40
        static let textFieldWidth: CGFloat = 325
        static let multilineHeight: CGFloat = 120
    }
    
    // MARK: - Fields
    let minHeight: CGFloat

    let axis: Axis
    let title: String
    let placeholder: String
    @Binding var text: String
        
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Const.cornerRadius)
                .stroke(.secondary, lineWidth: Const.borderWidth)
                .frame(
                    minWidth: Const.textFieldWidth,
                    minHeight: axis == .horizontal ? minHeight : Const.multilineHeight
                )
            
            Text(title)
                .font(.InstrumentMedium16)
                .foregroundStyle(Color.appPrimaryText)
                .padding(Metrics.threeQuartersModule)
                .background(Color.appBackground)
                .offset(x: Metrics.oneAndHalfModule, y: -Metrics.doubleModule)
            
            if (axis == .horizontal) {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.placeholderGrey)).font(.InstrumentRegular13)
                    .padding(.horizontal, Metrics.doubleModule)
                    .padding(.vertical, Metrics.oneAndHalfModule)
                    .frame(minHeight: minHeight)
            } else {
                MultilineTextField(
                    text: $text,
                    placeholder: placeholder
                )
                .padding(.horizontal, Metrics.oneAndHalfModule)
                .padding(.top, Metrics.doubleModule)
                .padding(.bottom, Metrics.oneAndHalfModule)
                .frame(minHeight: minHeight)
            }
        }
        .padding(.top, Metrics.oneAndHalfModule)
        
    }
}

// MARK: - Multiline text field
struct MultilineTextField: View {
    
    // MARK: - Fields
    @Binding var text: String
    let placeholder: String
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .topLeading) {
                   if text.isEmpty {
                       Text(placeholder)
                           .font(.InstrumentRegular13)
                           .foregroundStyle(Color.placeholderGrey)
                           .padding(.top, Metrics.module)
                           .padding(.leading, Metrics.halfModule)
                   }
                   
                       TextEditor(text: $text)
                       .scrollContentBackground(.hidden)
                       .scrollIndicators(.hidden)
                       .font(.InstrumentRegular13)
                       .foregroundStyle(Color.appPrimaryText)
                       .background(Color.clear)
               }
    }
}

//#Preview {
//    OutlinedInputField(title:"Title", placeholder: "")
//}
