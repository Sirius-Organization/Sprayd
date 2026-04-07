//
//  UIImageView+CachedAsyncImage.swift
//  Sprayd
//
//  Created by User on 07.04.2026.
//

import ObjectiveC
import UIKit

private enum CachedImageAssociatedKeys {
    static var task: UInt8 = 0
    static var representedURLString: UInt8 = 0
}

extension UIImageView {
    private var cachedImageTask: Task<Void, Never>? {
        get {
            objc_getAssociatedObject(self, &CachedImageAssociatedKeys.task) as? Task<Void, Never>
        }
        set {
            objc_setAssociatedObject(
                self,
                &CachedImageAssociatedKeys.task,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    private var representedURLString: String? {
        get {
            objc_getAssociatedObject(
                self,
                &CachedImageAssociatedKeys.representedURLString
            ) as? String
        }
        set {
            objc_setAssociatedObject(
                self,
                &CachedImageAssociatedKeys.representedURLString,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }

    func setCachedImage(
        from url: URL?,
        imageLoaderService: ImageLoaderService?,
        placeholder: UIImage?
    ) {
        cancelCachedImageLoad()
        image = placeholder
        representedURLString = url?.absoluteString

        guard
            let imageLoaderService,
            let urlString = url?.absoluteString
        else {
            return
        }

        cachedImageTask = Task { @MainActor [weak self] in
            guard
                let data = await imageLoaderService.loadImageData(from: urlString),
                !Task.isCancelled,
                let image = UIImage(data: data)
            else {
                return
            }

            guard self?.representedURLString == urlString else {
                return
            }

            self?.image = image
        }
    }

    func cancelCachedImageLoad() {
        cachedImageTask?.cancel()
        cachedImageTask = nil
        representedURLString = nil
    }
}
