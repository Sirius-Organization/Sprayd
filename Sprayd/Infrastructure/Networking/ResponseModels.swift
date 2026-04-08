//
//  ResponseModels.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 07.04.2026.
//

import Foundation

// MARK: - Error Models
struct APIErrorResponse: Codable, Error {
    let error: Bool
    let reason: String

}

struct ErrorDetail: Codable {
    let field: String
    let message: String
}

// MARK: - HTTP
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
