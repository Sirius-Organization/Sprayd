//
//  ImageLoaderService.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import Foundation
import SwiftData

@MainActor
final class ImageLoaderService {
    private let urlSession: URLSession
    private var memoryCache: [String: Data] = [:]

    init(
        modelContext _: ModelContext,
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }

    func loadImageData(from urlString: String) async -> Data? {
        if let memoryCachedData = memoryCache[urlString] {
            return memoryCachedData
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                return nil
            }

            memoryCache[urlString] = data
            return data
        } catch {
            return nil
        }
    }
}
