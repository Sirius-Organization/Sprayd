//
//  ArtAdditionMapper.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import Foundation

enum ArtAdditionMapper {
    static func mapArtist(_ response: ArtistResponse) -> Author {
        Author(
            id: response.id ?? UUID(),
            name: response.name,
            bio: response.bio,
            imageURLString: response.imagePath
        )
    }

    static func mapArtItem(_ response: ArtItemResponse) -> ArtItem {
        let images = response.firstImageUrl.map { [ArtImage(urlString: $0)] } ?? []

        return ArtItem(
            id: response.id ?? UUID(),
            name: response.name,
            itemDescription: response.itemDescription,
            storedImages: images,
            location: response.location,
            author: response.author,
            state: ArtState(rawValue: response.state) ?? .new,
            category: response.category,
            latitude: response.latitude,
            longitude: response.longitude
        )
    }
}
