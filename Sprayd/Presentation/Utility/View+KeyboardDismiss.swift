//
//  View+KeyboardDismiss.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 09.04.2026.
//

import SwiftUI
import UIKit

extension View {
    func dismissKeyboardOnTap() -> some View {
        contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            )
    }
}
