//
//  ArtItemAnnotationView.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit
import UIKit

final class ArtItemAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "ArtItemAnnotationView"
    
    private struct Constants {
        static let fatalError = "init(coder:) has not been implemented"
        static let annotationSize: CGFloat = 52
        static let annotationCornerRadius: CGFloat = 26
        static let countBadgeSize: CGFloat = 24
    }

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let countLabel = UILabel()
    private var imageTask: Task<Void, Never>?
    
    // MARK: Lifecycle

    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = UIImage()
        countLabel.isHidden = true
        countLabel.text = nil
    }
    
    // MARK: Configure

    func configure(
        annotation: any ArtMapAnnotation,
        imageProvider: ((String) async -> Data?)?
    ) {
        imageTask?.cancel()
        imageView.image = UIImage()

        if let clusterAnnotation = annotation as? ArtClusterAnnotation {
            countLabel.isHidden = false
            countLabel.text = "\(clusterAnnotation.annotationsCount)"
        } else {
            countLabel.isHidden = true
            countLabel.text = nil
        }

        guard
            let imageProvider,
            let urlString = annotation.imageURL?.absoluteString
        else {
            return
        }

        imageTask = Task { @MainActor [weak self] in
            guard
                let data = await imageProvider(urlString),
                let image = UIImage(data: data),
                !Task.isCancelled
            else {
                return
            }

            self?.imageView.image = image
        }
    }

    private func setupView() {
        frame = CGRect(
            x: 0,
            y: 0,
            width: Constants.annotationSize,
            height: Constants.annotationSize
        )
        centerOffset = CGPoint(x: 0, y: -26)
        canShowCallout = true
        collisionMode = .circle

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = Constants.annotationCornerRadius
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .red

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = .systemFont(ofSize: 13, weight: .bold)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .black
        countLabel.layer.cornerRadius = Constants.countBadgeSize / 2
        countLabel.clipsToBounds = true
        countLabel.isHidden = true

        addSubview(containerView)
        containerView.addSubview(imageView)
        addSubview(countLabel)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            countLabel.centerXAnchor.constraint(equalTo: containerView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: containerView.bottomAnchor),
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.countBadgeSize),
            countLabel.heightAnchor.constraint(equalToConstant: Constants.countBadgeSize)
        ])
    }
}
