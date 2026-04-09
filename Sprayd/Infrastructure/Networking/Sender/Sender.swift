//
//  Sender.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 07.04.2026.
//

import Foundation

final class Sender {
    
    private enum Constants {
        static let baseURL = "https://sprayd.ru/api/v1"

        static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()

        static let iso8601: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            return formatter
        }()
    }
    
    private let baseURL: String
    private let delays: [TimeInterval] = [1, 3, 10]
    
    init(baseURL: String = Constants.baseURL) {
        self.baseURL = baseURL
    }
    
    func send<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return try await sendWithRetry(
            request: request,
            endpoint: endpoint,
            method: method,
            headers: headers,
            body: body,
            attempt: 0
        )
    }
    
    func sendEmpty(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw try decodeErrorResponse(data)
        }
    }

    private func sendWithRetry<T: Decodable>(
        request: URLRequest,
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        attempt: Int
    ) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            if (500...599).contains(http.statusCode) {
                if attempt < delays.count {
                    try await Task.sleep(nanoseconds: UInt64(delays[attempt] * 1_000_000_000))
                    return try await sendWithRetry(
                        request: request,
                        endpoint: endpoint,
                        method: method,
                        headers: headers,
                        body: body,
                        attempt: attempt + 1
                    )
                } else {
                    throw try decodeErrorResponse(data)
                }
            }

            return try handleResponse(http, data: data)
        } catch {
            // Retry only transport-level failures.
            guard error is URLError else {
                throw error
            }
            if attempt < delays.count {
                try await Task.sleep(nanoseconds: UInt64(delays[attempt] * 1_000_000_000))
                return try await sendWithRetry(
                    request: request,
                    endpoint: endpoint,
                    method: method,
                    headers: headers,
                    body: body,
                    attempt: attempt + 1
                )
            } else {
                throw APIError.networkError(error)
            }
        }
    }
    
    private func handleResponse<T: Decodable>(_ response: HTTPURLResponse, data: Data) throws -> T {
        switch response.statusCode {
        case 200...299:
            return try decodeResponse(data)
        case 401:
            // TODO: refresh logic
            throw try decodeErrorResponse(data)
        default:
            throw try decodeErrorResponse(data)
        }
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = Constants.iso8601WithFractionalSeconds.date(from: dateString) {
                return date
            }
            if let date = Constants.iso8601.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    private func decodeErrorResponse(_ data: Data) throws -> APIErrorResponse {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(APIErrorResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
