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

    init(
        modelContext: ModelContext,
        urlSession: URLSession = .shared
    ) {
        self.modelContext = modelContext
        self.urlSession = urlSession
    }

    func loadImageData(from urlString: String) async -> Data? {
        if let storedData = fetchCachedImageData(for: urlString) {
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

            upsertCachedImage(data: data, for: urlString)
            return data
        } catch {
            return nil
        }
    }

    private func fetchCachedImageData(for urlString: String) -> Data? {
        let descriptor = FetchDescriptor<ArtImage>()
        let cachedImages = (try? modelContext.fetch(descriptor)) ?? []
        return cachedImages.first(where: { $0.urlString == urlString })?.img
    }

    private func upsertCachedImage(data: Data, for urlString: String) {
        let descriptor = FetchDescriptor<ArtImage>()
        let cachedImages = (try? modelContext.fetch(descriptor)) ?? []

        if let existingCache = cachedImages.first(where: { $0.urlString == urlString }) {
            existingCache.img = data
            existingCache.date = .now
        } else {
            let cachedImage = ArtImage(
                img: data,
                urlString: urlString
            )
            modelContext.insert(cachedImage)
        }

        try? modelContext.save()
    }
}
