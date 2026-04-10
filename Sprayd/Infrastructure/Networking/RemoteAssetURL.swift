//
//  RemoteAssetURL.swift
//  Sprayd
//
//  Created by User on 10.04.2026.
//

import Foundation

enum RemoteAssetURL {
    nonisolated private static let rootHost = "sprayd.ru"
    nonisolated private static let wwwRootHost = "www.sprayd.ru"
    nonisolated private static let baseURL = URL(string: "https://sprayd.ru")!

    nonisolated static func normalizedString(_ rawValue: String) -> String {
        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return ""
        }

        return normalizedURL(from: trimmedValue)?.absoluteString ?? trimmedValue
    }

    nonisolated static func normalizedURL(from rawValue: String?) -> URL? {
        guard let rawValue else {
            return nil
        }

        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        if trimmedValue.hasPrefix("//") {
            return normalizedURL(from: "https:\(trimmedValue)")
        }

        if trimmedValue.hasPrefix("/") {
            return baseURL.appending(path: String(trimmedValue.drop(while: { $0 == "/" })))
        }

        if trimmedValue.hasPrefix("images/") {
            return baseURL.appending(path: trimmedValue)
        }

        if trimmedValue.hasPrefix("\(rootHost)/") || trimmedValue == rootHost {
            return normalizedURL(from: "https://\(trimmedValue)")
        }

        if trimmedValue.hasPrefix("\(wwwRootHost)/") || trimmedValue == wwwRootHost {
            return normalizedURL(from: "https://\(trimmedValue)")
        }

        guard var components = URLComponents(string: trimmedValue) else {
            return nil
        }

        if components.scheme == nil, components.host == nil {
            return nil
        }

        if
            components.scheme?.lowercased() == "http",
            let normalizedHost = normalizedHost(from: components.host),
            normalizedHost == rootHost
        {
            components.scheme = "https"
            components.host = normalizedHost
        }

        return components.url
    }

    nonisolated private static func normalizedHost(from host: String?) -> String? {
        switch host?.lowercased() {
        case rootHost, wwwRootHost:
            return rootHost
        default:
            return host?.lowercased()
        }
    }
}
