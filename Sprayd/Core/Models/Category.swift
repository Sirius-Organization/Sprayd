//
//  Category.swift
//  Sprayd
//
//  Created by loxxy on 03.04.2026.
//

import Foundation

struct Category: Identifiable, Hashable {
    let id: UUID
    var name: String
    var slug: String

    init(id: UUID = UUID(), name: String, slug: String? = nil) {
        self.id = id
        self.name = name
        self.slug = slug ?? name
    }
}
