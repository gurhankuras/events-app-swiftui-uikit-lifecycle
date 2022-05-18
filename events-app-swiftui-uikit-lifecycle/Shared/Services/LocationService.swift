//
//  LocationService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/14/22.
//

import Foundation
import CoreLocation

protocol LocationFetcher {
    func requestCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> ())
}

enum LocationServiceError: Error {
    case unauthorized
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationFetcher {
    let manager: CLLocationManager
    var completion: ((Result<CLLocation, Error>) -> ())?
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
        self.manager.distanceFilter = 100
    }
    
    func requestCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> ()) {
        self.completion = completion
        checkPermission()
    }
    
    
    private func checkPermission() {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            completion?(.failure(LocationServiceError.unauthorized))
        @unknown default:
            fatalError()
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let completion = completion else {
            return
        }

        switch manager.authorizationStatus {
        case .denied, .restricted:
            completion(.failure(LocationServiceError.unauthorized))
            return
        default:
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            completion?(.success(location))
            completion = nil
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
        manager.stopUpdatingLocation()
    }

}
