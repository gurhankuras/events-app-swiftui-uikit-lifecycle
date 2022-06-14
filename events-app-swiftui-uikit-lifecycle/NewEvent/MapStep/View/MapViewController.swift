//
//  MapViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit
import MapKit
import os
import SwiftUI
import RxCocoa
import RxSwift

final class LongButtonHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsUpdateConstraints()
    }
}

class MapViewController: UIViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: MapViewController.self))
    private let bag = DisposeBag()

    // MARK: MKMap
    private var map: MKMapView? = MKMapView()
    private var addedOverlays: [MKOverlay] = []
    private let delegate: MKMapViewDelegate = NewEventOverlayHandlingMapDelegate()
    private var currentPin: MKPointAnnotation?

    var viewModel: MapStepViewModel!
    var onNext: ((CLLocationCoordinate2D) -> ())?
    
    // MARK: Views
    lazy var currentLocationButton: UIView = {
        let getCurrentLocationButton = UIView()
        getCurrentLocationButton.backgroundColor = .systemPink
        getCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        getCurrentLocationButton.layer.cornerRadius = 20
        let image = UIImage(systemName: "location.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        getCurrentLocationButton.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: getCurrentLocationButton.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: getCurrentLocationButton.centerYAnchor)
        ])
        let getCurrentLocationButtonTap = UITapGestureRecognizer(target: self, action: #selector(fire))
        getCurrentLocationButton.addGestureRecognizer(getCurrentLocationButtonTap)
        return getCurrentLocationButton
    }()
    
    lazy var nextButton: UIHostingController<LongRoundedButton> = {
        let button = LongButtonHostingController(rootView: LongRoundedButton(text: "Next", active: .constant(true), action: { [weak self] in self?.nextPage()}))
        let v = button.view!
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var locationLoadingMessageLabel: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.tinted()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 13)
        configuration.attributedTitle = AttributedString("Getting current location...", attributes: container)
    
        
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .black.withAlphaComponent(0.5)
        configuration.background = background
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.contentEdgeInsets =
        //button.setTitle(, for: .normal)
        button.tintColor = .white // this will be the textColor
        button.isUserInteractionEnabled = false
        button.alpha = 0
        return button
    }()
    
    @objc func fire() {
        viewModel.fetchLocation()
    }
    
    func nextPage() {
        self.onNext?(viewModel.coordinate.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        setLayouts()
        setupMap()
        startSubscriptions()
    }
    
    private func startSubscriptions() {
        viewModel.coordinate
            .subscribe(onNext: { [weak self] coordinate in
                self?.replacePin(at: coordinate)
            })
            .disposed(by: bag)
        
        viewModel.loadBoundries()
            .subscribe { [weak self] features in
                self?.addCityOverlays(features)
            } onError: { [weak self] error in
                self?.adjustMapForFallback()
                print(error)
            }
            .disposed(by: bag)
        
        viewModel.fetchingCurrentLocation
            .skip(1)
            .subscribe(onNext: { [weak self] fetching in
            if fetching {
                self?.showLoadingLabel()
            } else {
                self?.hideLoadingLabel()
            }
        })
        .disposed(by: bag)
    }
    
    private func showLoadingLabel() {
        locationLoadingMessageLabel.alpha = 1
    }
    
    
    private func hideLoadingLabel() {
        locationLoadingMessageLabel.alpha = 0
    }
    
    private func addCityOverlays(_ features: [MKGeoJSONFeature]) {
        features.forEach { (feature) in
            guard let geometry = feature.geometry.first,
                let _ = feature.properties else {
                return;
            }
            self.viewModel.coordinate.accept(geometry.coordinate)
            self.map?.setRegion(.init(center: geometry.coordinate, latitudinalMeters: 100_000, longitudinalMeters: 100_000), animated: true)
            if let geo = geometry as? MKOverlay {
                self.addedOverlays.append(geo)
                self.map?.addOverlay(geo)
            }
        }
    }
    
    private func adjustMapForFallback() {
        let countryCenter = CLLocationCoordinate2D(latitude: 38.96, longitude: 35.24)
        DispatchQueue.main.async {
            self.map?.setRegion(.init(center: countryCenter, latitudinalMeters: 700_000, longitudinalMeters: 700_000), animated: true)
        }
        self.viewModel.coordinate.accept(countryCenter)
    }
    
    deinit {
        cleanUpMap()
        Self.logger.debug("deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Self.logger.debug("\(#function)")
        
    }
}

// MARK: MKMap related functions
extension MapViewController {
    private func setupMap() {
        guard let map = map else {
            return
        }
        let region = MKCoordinateRegion.init(center: viewModel.initialPosition,
                                             latitudinalMeters: CLLocationDistance.init(500),
                                             longitudinalMeters: CLLocationDistance.init(500))
        map.delegate = delegate
        map.setRegion(region, animated: true)
        map.setCenter(viewModel.initialPosition, animated: true)
        map.translatesAutoresizingMaskIntoConstraints = false
    
        
        let selectLocationGesture = UILongPressGestureRecognizer(target: self, action: #selector(getConvertedCoordinateFromMap(sender:)))
        map.addGestureRecognizer(selectLocationGesture)
    }
    
    @objc func getConvertedCoordinateFromMap(sender: UILongPressGestureRecognizer) {
        guard let map = map else {
            return
        }
        guard sender.state == .began else { return }
        let touchLocation = sender.location(in: map)
        let coordinate = map.convert(touchLocation, toCoordinateFrom: map)
        viewModel.coordinate.accept(coordinate)
    }
    
    
    private func replacePin(at coordinate: CLLocationCoordinate2D) {
        guard let map = map else {
            return
        }
        if let currentPin = currentPin {
            map.removeAnnotation(currentPin)
        }
        let pin = MKPointAnnotation()
        pin.title = "Selected"
        pin.subtitle = "I dont know"
        pin.coordinate = coordinate
        currentPin = pin
        map.addAnnotation(pin)
        map.setCenter(coordinate, animated: true)
    }
    
    private func cleanUpMap() {
        if let currentPin = currentPin {
            self.map?.removeAnnotation(currentPin)
        }
        self.map?.removeOverlays(addedOverlays)
        self.map?.showsUserLocation = false;
        self.map?.delegate = nil;
        map?.removeFromSuperview()
        self.map = nil;
    }
}


// MARK: Layout and views setup
extension MapViewController {
    private func addViews() {
        guard let map = map else {
            return
        }
        view.addSubview(map)
        view.addSubview(locationLoadingMessageLabel)
        view.addSubview(currentLocationButton)
        
        addChild(nextButton)
        nextButton.didMove(toParent: self)
        map.addSubview(nextButton.view!)
    }
    
    private func setLayouts() {
        guard let map = map else {
            return
        }
        guard let nextButtonView = nextButton.view else { fatalError("nextbutton has not view") }
        
        let locationLabelConstraints = [
            locationLoadingMessageLabel.topAnchor.constraint(equalTo: map.safeAreaLayoutGuide.topAnchor),
            //locationLoadingMessageLabel.leadingAnchor.constraint(equalTo: map.safeAreaLayoutGuide.leadingAnchor),
            //locationLoadingMessageLabel.trailingAnchor.constraint(equalTo: map.safeAreaLayoutGuide.trailingAnchor)
            locationLoadingMessageLabel.centerYAnchor.constraint(equalTo: currentLocationButton.centerYAnchor),
            locationLoadingMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //locationLoadingMessageLabel.trailingAnchor.constraint(equalTo: currentLocationButton.leadingAnchor, constant: -10)
        ]
        
        let mapConstraints = [
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let locationButtonConstraints = [
            currentLocationButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 40),
        ]
        
        let nextButtonConstraints = [
            nextButtonView.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -40),
            nextButtonView.leadingAnchor.constraint(equalTo: map.leadingAnchor, constant: 20),
            nextButtonView.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(mapConstraints + locationButtonConstraints + nextButtonConstraints + locationLabelConstraints)
    }
}
