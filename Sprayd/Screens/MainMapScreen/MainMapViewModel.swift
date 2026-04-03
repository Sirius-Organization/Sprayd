//
//  MainMapViewModel.swift
//  Sprayd
//
//  Created by User on 01.04.2026.
//

import Foundation
import MapKit

@MainActor
@Observable
final class MainMapViewModel {
    var region: MKCoordinateRegion
    var items: [ArtItem]
    
    private let imageLoader: ImageLoaderService

    init(
        imageLoader: ImageLoaderService,
        region: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ),
        items: [ArtItem] = [
            ArtItem(
                name: "Москва",
                itemDescription: "Большой мурал в центре города",
                images: [
                    "https://images.example.com/moscow-1.jpg"
                ],
                location: "Moscow",
                author: "Ana Markov",
                state: .new,
                category: "Mural",
                latitude: 55.7558,
                longitude: 37.6176
            ),
            ArtItem(
                name: "Aboba",
                itemDescription: "Небольшой стрит-арт во дворе",
                images: [
                    "https://images.example.com/aboba-1.jpg"
                ],
                location: "Moscow",
                author: "Egor Maltsev",
                state: .new,
                category: "Sticker",
                latitude: 55.7558,
                longitude: 37.6276
            ),
            ArtItem(
                name: "Boba",
                itemDescription: "Работа рядом с набережной",
                images: [
                    "https://images.example.com/boba-1.jpg"
                ],
                location: "Moscow",
                author: "Liza Kurunok",
                state: .moderated,
                category: "Graffiti",
                latitude: 55.7558,
                longitude: 37.6076
            ),
            ArtItem(
                name: "Oba",
                itemDescription: "Фасадная работа на севере города",
                images: [
                    "https://images.example.com/oba-1.jpg"
                ],
                location: "Moscow",
                author: "Ana Markov",
                state: .exists,
                category: "Facade",
                latitude: 55.8558,
                longitude: 37.6176
            ),
            ArtItem(
                name: "Ba",
                itemDescription: "Миниатюра в спальном районе",
                images: [
                    "https://images.example.com/ba-1.jpg"
                ],
                location: "Moscow",
                author: "Sirius Team",
                state: .new,
                category: "Miniature",
                latitude: 55.7558,
                longitude: 37.5176
            )
        ]
    ) {
        self.imageLoader = imageLoader
        self.region = region
        self.items = items
    }
    
    func imageData(for urlString: String) async -> Data? {
        await imageLoader.loadImageData(from: urlString)
    }
}
