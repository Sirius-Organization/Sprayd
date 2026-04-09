//
//  ArtistResponse.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

struct ArtistResponse: Codable {
    let id: UUID?
    let name: String
    let bio: String
    let imagePath: String?
}
