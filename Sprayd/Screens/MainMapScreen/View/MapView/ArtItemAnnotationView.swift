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
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        imageView.image = UIImage(systemName: "photo")
        countLabel.isHidden = true
        countLabel.text = nil
    }

    func configure(
        annotation: any ArtMapAnnotation,
        imageProvider: ((String) async -> Data?)?
    ) {
        imageTask?.cancel()
        imageView.image = UIImage(systemName: "photo")

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
        frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        centerOffset = CGPoint(x: 0, y: -26)
        canShowCallout = true
        collisionMode = .circle

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 26
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = .systemFont(ofSize: 13, weight: .bold)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .black
        countLabel.layer.cornerRadius = 10
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
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),

            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 22),
            countLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
