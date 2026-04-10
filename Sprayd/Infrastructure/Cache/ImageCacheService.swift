//
//  ImageCacheService.swift
//  Sprayd
//
//  Created by User on 08.04.2026.
//

import Foundation

actor ImageCacheService {
    private struct CacheEntry {
        let fileURL: URL
        let size: UInt64
        let createdAt: Date
    }

    private let fileManager: FileManager
    private let cacheDirectoryURL: URL
    private let maxCacheSizeInBytes: UInt64

    init(
        fileManager: FileManager = .default,
        cacheDirectoryURL: URL? = nil,
        maxCacheSizeInBytes: UInt64 = 30 * 1024 * 1024
    ) {
        self.fileManager = fileManager
        self.maxCacheSizeInBytes = maxCacheSizeInBytes

        if let cacheDirectoryURL {
            self.cacheDirectoryURL = cacheDirectoryURL
        } else {
            let baseDirectory = fileManager.urls(
                for: .cachesDirectory,
                in: .userDomainMask
            ).first ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            self.cacheDirectoryURL = baseDirectory
                .appendingPathComponent("Sprayd", isDirectory: true)
                .appendingPathComponent("ImageCache", isDirectory: true)
        }

        try? fileManager.createDirectory(
            at: self.cacheDirectoryURL,
            withIntermediateDirectories: true
        )
    }

    func data(for url: URL) -> Data? {
        let baseURL = fileURL(for: url)
        guard fileManager.fileExists(atPath: baseURL.path) else {
            return nil
        }
        return try? Data(contentsOf: baseURL)
    }

    func store(_ data: Data, for url: URL) {
        guard UInt64(data.count) <= maxCacheSizeInBytes else {
            return
        }

        do {
            let destinationURL = fileURL(for: url)
            try data.write(to: destinationURL, options: .atomic)
            try trimIfNeeded()
        } catch {
            return
        }
    }

    func removeData(for url: URL) {
        let fileURL = fileURL(for: url)
        try? fileManager.removeItem(at: fileURL)
    }

    func removeAll() {
        try? fileManager.removeItem(at: cacheDirectoryURL)
        try? fileManager.createDirectory(
            at: cacheDirectoryURL,
            withIntermediateDirectories: true
        )
    }

    private func trimIfNeeded() throws {
        var entries = try cacheEntries().sorted { $0.createdAt < $1.createdAt }
        var currentSize = entries.reduce(UInt64.zero) { $0 + $1.size }

        while currentSize > maxCacheSizeInBytes, let oldestEntry = entries.first {
            try fileManager.removeItem(at: oldestEntry.fileURL)
            currentSize -= oldestEntry.size
            entries.removeFirst()
        }
    }

    private func cacheEntries() throws -> [CacheEntry] {
        guard fileManager.fileExists(atPath: cacheDirectoryURL.path) else {
            return []
        }

        let fileURLs = try fileManager.contentsOfDirectory(
            at: cacheDirectoryURL,
            includingPropertiesForKeys: [
                .creationDateKey,
                .contentModificationDateKey,
                .fileSizeKey,
                .isRegularFileKey
            ]
        )

        return fileURLs.compactMap { fileURL in
            guard
                let resourceValues = try? fileURL.resourceValues(forKeys: [
                    .creationDateKey,
                    .contentModificationDateKey,
                    .fileSizeKey,
                    .isRegularFileKey
                ]),
                resourceValues.isRegularFile == true
            else {
                return nil
            }

            let createdAt = resourceValues.creationDate
                ?? resourceValues.contentModificationDate
                ?? .distantPast
            let size = UInt64(resourceValues.fileSize ?? 0)

            return CacheEntry(
                fileURL: fileURL,
                size: size,
                createdAt: createdAt
            )
        }
    }

    private func fileURL(for url: URL) -> URL {
        let fileName = Data(url.absoluteString.utf8).base64EncodedString()

        return cacheDirectoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
}
