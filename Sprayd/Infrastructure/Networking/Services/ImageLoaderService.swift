//
//  ImageLoaderService.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import Foundation

@MainActor
final class ImageLoaderService {
    private let urlSession: URLSession
    private let imageCacheService: ImageCacheService

    init(
        imageCacheService: ImageCacheService,
        urlSession: URLSession = .shared
    ) {
        self.imageCacheService = imageCacheService
        self.urlSession = urlSession
    }

    func loadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        if let cachedData = await imageCacheService.data(for: url) {
            return cachedData
        }

        do {
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                return nil
            }

            await imageCacheService.store(data, for: url)
            return data
        } catch {
            return nil
        }
    }
}
