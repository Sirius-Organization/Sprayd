//
//  ArtMapAnnotation.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import Foundation

protocol ArtMapAnnotation: AnyObject {
    var imageURL: URL? { get }
    var author: String? { get }
    var itemDescription: String? { get }
}
