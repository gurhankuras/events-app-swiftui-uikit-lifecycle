//
//  MapStepViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import Foundation
import RxCocoa
import RxSwift
import MapKit
import os

class MapStepViewModel {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: MapStepViewModel.self))
    let initialPosition: CLLocationCoordinate2D

    private let locationManager = LocationService(manager: .init())
    private let geoJsonProvider: GeoJsonProvider

    
    let coordinate: BehaviorRelay<CLLocationCoordinate2D>
    let locationRequest = PublishRelay<Void>()
    let didLoadBoundries = PublishRelay<[MKGeoJSONFeature]>()
    let fetchingCurrentLocation = BehaviorRelay<Bool>(value: false)
        
    let bag = DisposeBag()

    init(geoJsonProvider: GeoJsonProvider) {
        self.geoJsonProvider = geoJsonProvider
        initialPosition = .init(latitude: 40.986, longitude: 29.283)
        coordinate = BehaviorRelay<CLLocationCoordinate2D>(value: initialPosition)
        locationRequest
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.getCurrentLocation()
            })
            .disposed(by: bag)
    }
    
    func loadBoundries() -> Observable<[MKGeoJSONFeature]> {
        return Observable.create { [weak self] observer in
            self?.geoJsonProvider.load { result in
                switch result {
                case .success(let features):
                    observer.onNext(features)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
    
    func fetchLocation() {
        locationRequest.accept(())
    }
    
    private func getCurrentLocation() {
        Self.logger.debug("\(#function) - Started fetching ")
        fetchingCurrentLocation.accept(true)
        locationManager.requestCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.coordinate.accept(location.coordinate)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.fetchingCurrentLocation.accept(false)
        }
    }
}
