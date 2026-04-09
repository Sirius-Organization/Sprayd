//
//  ArtItemImageMerger.swift
//  Sprayd
//
//  Created by Egor on 09.04.2026.
//

import CryptoKit
import Foundation
import SwiftData

enum ArtItemImageMergeMode {
    case preserveExisting
    case replaceAll
}

struct RemoteArtImagePayload {
    let remoteID: UUID?
    let urlString: String
    let createdAt: Date?
    let timeStamp: TimeInterval?
    let userID: UUID?
}

enum ArtItemImageMerger {
    static func merge(
        _ remoteImages: [RemoteArtImagePayload],
        into localItem: ArtItem,
        modelContext: ModelContext,
        mode: ArtItemImageMergeMode
    ) {
        let normalizedRemoteImages = normalized(remoteImages)

        switch mode {
        case .preserveExisting:
            guard !normalizedRemoteImages.isEmpty else { return }
        case .replaceAll:
            break
        }

        var orderedImages: [ArtImage] = []
        orderedImages.reserveCapacity(normalizedRemoteImages.count)

        for remoteImage in normalizedRemoteImages {
            let image = upsertImage(
                for: remoteImage,
                in: localItem,
                modelContext: modelContext
            )

            if !orderedImages.contains(where: { $0 === image }) {
                orderedImages.append(image)
            }
        }

        switch mode {
        case .preserveExisting:
            let existingOrderedImages = localItem.images.filter { localImage in
                orderedImages.contains(where: { $0 === localImage })
            }

            let newlyAddedImages = orderedImages.filter { remoteImage in
                !existingOrderedImages.contains(where: { $0 === remoteImage })
            }

            let preservedImages = localItem.images.filter { localImage in
                !existingOrderedImages.contains(where: { $0 === localImage })
            }

            localItem.images = existingOrderedImages + newlyAddedImages + preservedImages

        case .replaceAll:
            orderedImages = reorderedForStablePresentation(
                orderedImages,
                remoteImages: normalizedRemoteImages,
                localItem: localItem
            )

            let imagesToDelete = localItem.images.filter { localImage in
                !normalizedRemoteImages.contains { remoteImage in
                    matches(localImage, remoteImage: remoteImage)
                }
            }

            for image in imagesToDelete {
                modelContext.delete(image)
            }

            localItem.images = orderedImages
        }
    }

    private static func reorderedForStablePresentation(
        _ remoteOrderedImages: [ArtImage],
        remoteImages: [RemoteArtImagePayload],
        localItem: ArtItem
    ) -> [ArtImage] {
        var stableImages: [ArtImage] = []
        stableImages.reserveCapacity(remoteOrderedImages.count)

        for localImage in localItem.images {
            guard let remoteMatch = remoteImages.first(where: { remoteImage in
                matches(localImage, remoteImage: remoteImage)
            }) else {
                continue
            }

            guard let remoteImage = remoteOrderedImages.first(where: { candidate in
                matches(candidate, remoteImage: remoteMatch)
            }) else {
                continue
            }

            if !stableImages.contains(where: { $0 === remoteImage }) {
                stableImages.append(remoteImage)
            }
        }

        for remoteImage in remoteOrderedImages where !stableImages.contains(where: { $0 === remoteImage }) {
            stableImages.append(remoteImage)
        }

        return stableImages
    }

    private static func normalized(
        _ remoteImages: [RemoteArtImagePayload]
    ) -> [RemoteArtImagePayload] {
        var seenKeys: Set<String> = []
        var result: [RemoteArtImagePayload] = []
        result.reserveCapacity(remoteImages.count)

        for remoteImage in remoteImages {
            let urlString = remoteImage.urlString
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !urlString.isEmpty else { continue }

            let key = remoteImage.remoteID?.uuidString ?? urlString
            guard seenKeys.insert(key).inserted else { continue }

            result.append(
                RemoteArtImagePayload(
                    remoteID: remoteImage.remoteID,
                    urlString: urlString,
                    createdAt: remoteImage.createdAt,
                    timeStamp: remoteImage.timeStamp,
                    userID: remoteImage.userID
                )
            )
        }

        return result
    }

    private static func upsertImage(
        for remoteImage: RemoteArtImagePayload,
        in localItem: ArtItem,
        modelContext: ModelContext
    ) -> ArtImage {
        let existingByID = remoteImage.remoteID.flatMap { remoteID in
            localItem.images.first { $0.id == remoteID }
        }

        let existingByURL = localItem.images.first { image in
            normalized(image.urlString) == remoteImage.urlString
        }

        let image = existingByID ?? existingByURL ?? makeImage(
            from: remoteImage,
            modelContext: modelContext
        )

        if
            let existingByID,
            let existingByURL,
            existingByID !== existingByURL {
            localItem.images.removeAll { $0 === existingByURL }
            modelContext.delete(existingByURL)
        }

        if let remoteID = remoteImage.remoteID {
            image.id = remoteID
        }

        image.urlString = remoteImage.urlString

        if let createdAt = remoteImage.createdAt {
            image.createdAt = createdAt
        }

        if let timeStamp = remoteImage.timeStamp {
            image.timeStamp = timeStamp
        }

        if let userID = remoteImage.userID {
            image.userID = userID
        }

        return image
    }

    private static func makeImage(
        from remoteImage: RemoteArtImagePayload,
        modelContext: ModelContext
    ) -> ArtImage {
        let image = ArtImage(
            id: remoteImage.remoteID ?? stableUUID(for: remoteImage.urlString),
            urlString: remoteImage.urlString,
            createdAt: remoteImage.createdAt ?? Date(timeIntervalSince1970: 0),
            timeStamp: remoteImage.timeStamp ?? 0,
            userID: remoteImage.userID
        )
        modelContext.insert(image)
        return image
    }

    private static func matches(
        _ localImage: ArtImage,
        remoteImage: RemoteArtImagePayload
    ) -> Bool {
        if let remoteID = remoteImage.remoteID, localImage.id == remoteID {
            return true
        }

        return normalized(localImage.urlString) == remoteImage.urlString
    }

    private static func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func stableUUID(for value: String) -> UUID {
        let digest = Insecure.MD5.hash(data: Data(value.utf8))
        let bytes = Array(digest)
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }
}
