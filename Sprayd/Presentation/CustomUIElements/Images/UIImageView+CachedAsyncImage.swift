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

    func setImage(
        from url: URL?,
        imageLoaderService: ImageLoaderService?,
        placeholder: UIImage?
    ) {
        cancelImageLoad()
        image = placeholder

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

            self?.image = image
        }
    }

    func cancelImageLoad() {
        cachedImageTask?.cancel()
        cachedImageTask = nil
    }
}
