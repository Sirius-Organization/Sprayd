//
//  Metrics.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 03.04.2026.
//

import Foundation

struct Metrics {
    /// 4
    static let halfModule: CGFloat = 4
    
    /// 6
    static var threeQuartersModule: CGFloat { halfModule * 1.5 }
    
    /// 8
    static var module: CGFloat { halfModule * 2 }
    
    /// 12
    static var oneAndHalfModule: CGFloat { module * 1.5 }
    
    /// 16
    static var doubleModule: CGFloat { module * 2 }
    
    /// 20
    static var twoAndHalfModule: CGFloat { module * 2.5 }
    
    /// 24
    static var tripleModule: CGFloat { module * 3 }
    
    /// 32
    static var quadrupleModule: CGFloat { doubleModule * 2 }
    
    /// 80
    static var tenTimesModule: CGFloat { module * 10 }
}
