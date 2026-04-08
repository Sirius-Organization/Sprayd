//
//  CachedAsyncImage.swift
//  Sprayd
//
//  Created by User on 07.04.2026.
//

import SwiftUI
import UIKit

enum CachedAsyncImagePhase {
    case empty
    case success(Image)
    case failure
}

private struct ImageLoaderServiceKey: EnvironmentKey {
    static let defaultValue: ImageLoaderService? = nil
}

extension EnvironmentValues {
    var imageLoaderService: ImageLoaderService? {
        get { self[ImageLoaderServiceKey.self] }
        set { self[ImageLoaderServiceKey.self] = newValue }
    }
}

extension View {
    func imageLoaderService(_ service: ImageLoaderService?) -> some View {
        environment(\.imageLoaderService, service)
    }
}

struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let transaction: Transaction
    private let content: (CachedAsyncImagePhase) -> Content

    @Environment(\.imageLoaderService) private var imageLoaderService
    @State private var phase: CachedAsyncImagePhase = .empty

    init(
        url: URL?,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (CachedAsyncImagePhase) -> Content
    ) {
        self.url = url
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        content(phase)
            .task(id: url?.absoluteString) {
                await loadImage()
            }
    }

    private func loadImage() async {
        updatePhase(.empty)

        guard
            let imageLoaderService,
            let urlString = url?.absoluteString
        else {
            return
        }

        guard
            let data = await imageLoaderService.loadImageData(from: urlString),
            !Task.isCancelled,
            let uiImage = UIImage(data: data)
        else {
            guard !Task.isCancelled else { return }
            updatePhase(.failure)
            return
        }

        updatePhase(.success(Image(uiImage: uiImage)))
    }

    @MainActor
    private func updatePhase(_ phase: CachedAsyncImagePhase) {
        withTransaction(transaction) {
            self.phase = phase
        }
    }
}
