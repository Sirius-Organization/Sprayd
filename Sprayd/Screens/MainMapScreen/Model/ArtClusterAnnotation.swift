//
//  ArtClusterAnnotation.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit

final class ArtClusterAnnotation: MKClusterAnnotation, ArtMapAnnotation {
    private let firstArtAnnotation: ArtItemAnnotation?

    override init(memberAnnotations: [any MKAnnotation]) {
        self.firstArtAnnotation = memberAnnotations.compactMap { $0 as? ArtItemAnnotation }.first
        super.init(memberAnnotations: memberAnnotations)
        title = firstArtAnnotation?.title
        subtitle = firstArtAnnotation?.subtitle
    }

    var imageURL: URL? {
        firstArtAnnotation?.imageURL
    }

    var author: String? {
        firstArtAnnotation?.author
    }

    var itemDescription: String? {
        firstArtAnnotation?.itemDescription
    }

    var annotationsCount: Int {
        memberAnnotations.count
    }
}
