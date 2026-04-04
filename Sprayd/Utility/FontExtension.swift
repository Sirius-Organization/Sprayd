//
//  FontExtension.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI
import UIKit

extension Font {
    static let InstrumentRegular13 = Font.custom("InstrumentSans-Regular", size: 13)
    static let InstrumentRegular18 = Font.custom("InstrumentSans-Regular", size: 18)

    static let InstrumentBold22 = Font.custom("InstrumentSans-Bold", size: 22)
    static let InstrumentBold20 = Font.custom("InstrumentSans-Bold", size: 20)
    static let InstrumentBold17 = Font.custom("InstrumentSans-Bold", size: 17)
    static let InstrumentBold13 = Font.custom("InstrumentSans-Bold", size: 13)
    
    static let InstrumentMedium16 = Font.custom("InstrumentSans-Medium", size: 16)
    static let InstrumentMedium10 = Font.custom("InstrumentSans-Medium", size: 10)
    static let InstrumentMedium13 = Font.custom("InstrumentSans-Medium", size: 13)
    static let InstrumentMedium18 = Font.custom("InstrumentSans-Medium", size: 18)
    static let InstrumentMedium20 = Font.custom("InstrumentSans-Medium", size: 20)
    
    static let ClimateCrisisRegular22 = Font.custom("ClimateCrisis-Regular", size: 22)
    static let ClimateCrisisRegular20 = Font.custom("Climate Crisis", size: 20)
}

extension UIFont {
    static let InstrumentBold13 = UIFont(
        name: "InstrumentSans-Bold",
        size: 13
    ) ?? .boldSystemFont(ofSize: 13)
}
