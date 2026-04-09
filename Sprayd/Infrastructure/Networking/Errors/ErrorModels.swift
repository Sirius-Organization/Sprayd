//
//  ErrorModels.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

struct APIErrorResponse: Codable, Error {
    let error: Bool
    let errorMessage: String

}

struct ErrorDetail: Codable {
    let field: String
    let message: String
}
