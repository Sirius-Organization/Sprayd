//
//  AuthorizationService.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 08.04.2026.
//

import Foundation

final class AuthorizationService {

    private let sender: Sender

    init(sender: Sender) {
        self.sender = sender
    }

    // MARK: - Models

    private struct RegisterRequest: Codable {
        let email: String
        let password: String
    }

    struct RegisterResponse: Codable {
        let id: UUID?
        let email: String
    }

    struct LoginResponse: Codable {
        let token: String
    }

    // MARK: - API

    /// POST /auth/register
    func register(email: String, password: String) async throws -> RegisterResponse {
        let body = try JSONEncoder().encode(RegisterRequest(email: email, password: password))

        return try await sender.send(
            endpoint: "/auth/register",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: body
        )
    }

    /// POST /auth/login  (Basic Auth)
    func login(email: String, password: String) async throws -> LoginResponse {
        let credentials = "\(email):\(password)"
        guard let data = credentials.data(using: .utf8) else {
            throw APIError.invalidRequest
        }
        let base64 = data.base64EncodedString()

        return try await sender.send(
            endpoint: "/auth/login",
            method: .post,
            headers: ["Authorization": "Basic \(base64)"]
        )
    }

    /// POST /auth/logout  (Bearer Token)
    func logout(token: String) async throws {
        try await sender.sendEmpty(
            endpoint: "/auth/logout",
            method: .post,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}
