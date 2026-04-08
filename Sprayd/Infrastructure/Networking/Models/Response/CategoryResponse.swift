//
//  CategoryResponse.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

struct CategoryResponse: Codable {
    let id: UUID?
    let name: String
    let slug: String
}

