//
//  ArtImage.swift
//  Sprayd
//
//  Created by User on 04.04.2026.
//

import Foundation
import SwiftData

@Model
final class ArtImage {
    var urlString: String

    init(urlString: String = "") {
        self.urlString = urlString
    }
}
