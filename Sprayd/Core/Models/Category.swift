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

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
