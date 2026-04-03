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
        static let titlePadding: CGFloat = 6
        
        static let textFieldHeight: CGFloat = 40
        static let textFieldWidth: CGFloat = 325
        
        static let titleXOffset: CGFloat = 10
        static let titleYOffset: CGFloat = -16
        
        static let multilineHeight: CGFloat = 120
        
        // Strings
        
        // Fonts
        static let titleFont: Font = .InstrumentMedium16
        static let placeholderFont: Font = .InstrumentRegular13
        
        // Icons
        
        // Colors
        static let borderColor: Color = .secondaryColor
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
                .stroke(Const.borderColor, lineWidth: Const.borderWidth)
                .frame(
                    minWidth: Const.textFieldWidth,
                    minHeight: axis == .horizontal ? minHeight : Const.multilineHeight
                )
            
            Text(title)
                .font(Const.titleFont)
                .foregroundStyle(Color.black)
                .padding(Const.titlePadding)
                .background(Color.appBackground)
                .offset(x: Const.titleXOffset, y: Const.titleYOffset)
            
            if (axis == .horizontal) {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.placeholderGrey)).font(Const.placeholderFont)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .frame(minHeight: minHeight)
            } else {
                MultilineTextField(
                    text: $text,
                    placeholder: placeholder
                )
                .padding(.horizontal, 14)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .frame(minHeight: minHeight)
            }
        }
        .padding(.top, 10)
        
    }
}

// MARK: - Multiline text field

struct MultilineTextField: View {
    // MARK: - Const
    private enum Const {
        // UI Constraint properties
        // Strings
        
        // Fonts
        static let textFont: Font = .InstrumentRegular13
        
        // Icons
        // Colors
    }
    
    // MARK: - Fields
    @Binding var text: String
    let placeholder: String
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .topLeading) {
                   if text.isEmpty {
                       Text(placeholder)
                           .font(Const.textFont)
                           .foregroundStyle(Color.placeholderGrey)
                           .padding(.top, 8)
                           .padding(.leading, 5)
                   }
                   
                   TextEditor(text: $text)
                       .scrollContentBackground(.hidden)
                       .font(Const.textFont)
                       .foregroundStyle(Color.black)
                       .background(Color.clear)
               }
    }
}

//#Preview {
//    OutlinedInputField(title:"Title", placeholder: "")
//}
