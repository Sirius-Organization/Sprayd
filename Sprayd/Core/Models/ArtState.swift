//
//  ArtState.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import Foundation

enum ArtState: String, Codable, CaseIterable {
    case new
    case exists
    case moderated
}
