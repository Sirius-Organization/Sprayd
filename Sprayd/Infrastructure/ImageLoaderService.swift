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
    private let modelContext: ModelContext
    private let urlSession: URLSession
    private var memoryCache: [String: Data] = [:]

    init(
        modelContext: ModelContext,
        urlSession: URLSession = .shared
    ) {
        self.modelContext = modelContext
        self.urlSession = urlSession
    }

    func loadImageData(from urlString: String) async -> Data? {
        if let memoryCachedData = memoryCache[urlString] {
            return memoryCachedData
        }

        if let storedData = fetchCachedImageData(for: urlString) {
            memoryCache[urlString] = storedData
            return storedData
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
            upsertCachedImage(data: data, for: urlString)
            return data
        } catch {
            return nil
        }
    }

    private func fetchCachedImageData(for urlString: String) -> Data? {
        cachedImage(for: urlString)?.img
    }

    private func upsertCachedImage(data: Data, for urlString: String) {
        if let existingCache = cachedImage(for: urlString) {
            existingCache.img = data
            existingCache.date = .now
            existingCache.timeStamp = Date().timeIntervalSince1970
        } else {
            let cachedImage = ArtImage(
                img: data,
                urlString: urlString
            )
            modelContext.insert(cachedImage)
        }

        try? modelContext.save()
    }

    private func cachedImage(for urlString: String) -> ArtImage? {
        var descriptor = FetchDescriptor<ArtImage>(
            predicate: #Predicate<ArtImage> { image in
                image.urlString == urlString
            }
        )
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }
}
