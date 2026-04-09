//
//  ApiError.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 07.04.2026.
//

import Foundation

// TODO: maybe there are some extra errors idk
// Equatable for unitTests
enum APIError: Error, Equatable {
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidURL
    case invalidRequest
    case networkError(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case unknown
}
