//
//  LocationProvider.swift
//  Sprayd
//
//  Created by Codex on 09.04.2026.
//

import CoreLocation
import Foundation
import Combine

@MainActor
final class LocationProvider: NSObject {
    
    private let locationManager: CLLocationManager
    
    @Published var currentLocation: CLLocation?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorize() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Location manager delegate extension

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}
