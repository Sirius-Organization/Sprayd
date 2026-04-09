//
//  FeedRoute.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import Foundation

enum FeedRoute: Hashable {
    case artObject(UUID)
    case artistProfile(String)
    case userProfile(String)
}
