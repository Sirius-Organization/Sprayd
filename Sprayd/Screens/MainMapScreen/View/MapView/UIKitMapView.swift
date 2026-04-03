//
//  MapView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import MapKit

struct UIKitMapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let items: [ArtItem]
    let imageProvider: (String) async -> Data?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(
            ArtItemAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: ArtItemAnnotationView.reuseIdentifier
        )
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.imageProvider = imageProvider
        updateRegion(for: uiView)
        updateAnnotations(for: uiView)
    }

    func makeCoordinator() -> UIKitMapCoordinator {
        UIKitMapCoordinator(imageProvider: imageProvider)
    }

    private func updateRegion(for mapView: MKMapView) {
        if mapView.region.center.latitude != region.center.latitude ||
           mapView.region.center.longitude != region.center.longitude ||
           mapView.region.span.latitudeDelta != region.span.latitudeDelta ||
           mapView.region.span.longitudeDelta != region.span.longitudeDelta {
            mapView.setRegion(region, animated: true)
        }
    }

    private func updateAnnotations(for mapView: MKMapView) {
        let existingAnnotations = mapView.annotations.compactMap { $0 as? ArtItemAnnotation }
        let existingAnnotationsByID = Dictionary(
            uniqueKeysWithValues: existingAnnotations.map { ($0.itemIdentifier, $0) }
        )
        let targetIDs = Set(items.map { ObjectIdentifier($0) })

        let annotationsToRemove = existingAnnotations.filter { annotation in
            !targetIDs.contains(annotation.itemIdentifier)
        }

        let annotationsToAdd = items.compactMap { item -> ArtItemAnnotation? in
            let itemID = ObjectIdentifier(item)
            guard existingAnnotationsByID[itemID] == nil else {
                return nil
            }

            return ArtItemAnnotation(item: item)
        }

        if !annotationsToRemove.isEmpty {
            mapView.removeAnnotations(annotationsToRemove)
        }

        if !annotationsToAdd.isEmpty {
            mapView.addAnnotations(annotationsToAdd)
        }
    }
}

// MARK: - Coordinator

// Так как используется только в MapView объявляем здесь
final class UIKitMapCoordinator: NSObject, MKMapViewDelegate {
    var imageProvider: (String) async -> Data?

    init(imageProvider: @escaping (String) async -> Data?) {
        self.imageProvider = imageProvider
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var identifier: String?
        if annotation is ArtClusterAnnotation {
            identifier = nil
        } else if annotation is ArtMapAnnotation {
            identifier = "art-item"
        } else {
            return nil
        }

        guard let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: ArtItemAnnotationView.reuseIdentifier,
            for: annotation
        ) as? ArtItemAnnotationView else { return nil }
        view.clusteringIdentifier = identifier

        if let artAnnotation = annotation as? any ArtMapAnnotation {
            view.configure(
                annotation: artAnnotation,
                imageProvider: imageProvider
            )
        }

        return view
    }

    func mapView(
        _ mapView: MKMapView,
        clusterAnnotationForMemberAnnotations memberAnnotations: [any MKAnnotation]
    ) -> MKClusterAnnotation {
        ArtClusterAnnotation(memberAnnotations: memberAnnotations)
    }
}
