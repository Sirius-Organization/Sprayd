//
//  ArtItemAnnotationView.swift
//  Sprayd
//
//  Created by User on 03.04.2026.
//

import MapKit
import SwiftUI
import UIKit

final class ArtItemAnnotationView: MKAnnotationView {
    static let annotationReuseIdentifier = "ArtItemAnnotationView"
    static let clusterReuseIdentifier = "ArtClusterAnnotationView"
    static let clusteringIdentifier = "art-item"

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let countLabel = UILabel()
    
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
        imageView.cancelImageLoad()
        imageView.image = placeholderImage()
        countLabel.isHidden = true
        countLabel.text = nil
        setNeedsLayout()
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        bounds = CGRect(
            origin: .zero,
            size: CGSize(
                width: Metrics.eightTimesModule,
                height: Metrics.eightTimesModule
            )
        )
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bounds = CGRect(
            origin: .zero,
            size: CGSize(
                width: Metrics.eightTimesModule,
                height: Metrics.eightTimesModule
            )
        )
        containerView.frame = bounds
        imageView.frame = containerView.bounds

        let labelWidth = max(
            Metrics.tripleModule,
            countLabel.intrinsicContentSize.width + Metrics.module
        )
        countLabel.frame = CGRect(
            x: containerView.frame.maxX - labelWidth / 2,
            y: containerView.frame.maxY - Metrics.tripleModule / 2,
            width: labelWidth,
            height: Metrics.tripleModule
        ).integral
    }
    
    // MARK: Configure

    func configure(
        annotation: any MKAnnotation,
        imageLoaderService: ImageLoaderService?
    ) {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            countLabel.isHidden = false
            countLabel.text = "\(clusterAnnotation.memberAnnotations.count)"
        } else {
            countLabel.isHidden = true
            countLabel.text = nil
        }
        setNeedsLayout()

        let imageURL: URL?
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            imageURL = clusterAnnotation.memberAnnotations
                .compactMap { $0 as? ArtItemAnnotation }
                .first?
                .imageURL
        } else {
            imageURL = (annotation as? ArtItemAnnotation)?.imageURL
        }

        imageView.setImage(
            from: imageURL,
            imageLoaderService: imageLoaderService,
            placeholder: placeholderImage()
        )
    }

    private func setupView() {
        bounds = CGRect(
            origin: .zero,
            size: CGSize(
                width: Metrics.eightTimesModule,
                height: Metrics.eightTimesModule
            )
        )
        clipsToBounds = false
        centerOffset = .zero
        canShowCallout = false
        collisionMode = .circle

        containerView.frame = bounds
        containerView.backgroundColor = UIColor(Color.appBackground)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = Metrics.tripleModule
        containerView.layer.borderWidth = Metrics.halfModule
        containerView.layer.borderColor = UIColor(Color.appBackground).cgColor

        imageView.frame = containerView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(Color.placeholderGrey)
        imageView.image = placeholderImage()

        countLabel.font = .InstrumentBold13
        countLabel.textColor = UIColor(Color.appBackground)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor(Color.accentRed)
        countLabel.layer.cornerRadius = Metrics.threeQuartersModule
        countLabel.clipsToBounds = true
        countLabel.isHidden = true

        addSubview(containerView)
        containerView.addSubview(imageView)
        addSubview(countLabel)
    }

    private func placeholderImage() -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: Metrics.doubleModule,
            weight: .medium
        )
        return UIImage(systemName: "photo", withConfiguration: configuration)?
            .withTintColor(UIColor(Color.placeholderGrey), renderingMode: .alwaysOriginal)
    }
}
