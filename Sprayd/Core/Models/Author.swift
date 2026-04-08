//
//  Author.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import Foundation
import SwiftData

@Model
final class Author {
    @Attribute(.unique) var id: UUID
    var name: String
    var bio: String
    var imageURLString: String?

    init(
        id: UUID = UUID(),
        name: String = "",
        bio: String = "",
        imageURLString: String? = nil
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.imageURLString = imageURLString
    }
}
