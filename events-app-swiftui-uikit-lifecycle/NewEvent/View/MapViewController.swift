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

class MapStepViewModel {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: MapStepViewModel.self))
    let bag = DisposeBag()
    let initialPosition: CLLocationCoordinate2D
    private var overlays: [MKOverlay] = []
    let coordinate: BehaviorRelay<CLLocationCoordinate2D>
    let locationManager = LocationService(manager: .init())
    let locationRequest = PublishRelay<Void>()

    init() {
        initialPosition = .init(latitude: 40.986, longitude: 29.283)
        coordinate = BehaviorRelay<CLLocationCoordinate2D>(value: initialPosition)
        locationRequest
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.getCurrentLocation()
            })
            .disposed(by: bag)
    }
    
    func fetchLocation() {
        locationRequest.accept(())
    }
    
    private func getCurrentLocation() {
        Self.logger.debug("\(#function) - Started fetching ")
        locationManager.requestCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.coordinate.accept(location.coordinate)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


class MapViewController: UIViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: MapViewController.self))
    var map: MKMapView? = MKMapView()
    weak var weakSelf: MapViewController?
    var overlays: [MKOverlay] = []
    let delegate: MapDelegate = MapDelegate()
    let viewModel = MapStepViewModel()
    let bag = DisposeBag()
    var onNext: ((CLLocationCoordinate2D) -> ())?
    private var currentPin: MKPointAnnotation?

    
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
        
        
        viewModel.coordinate
            .subscribe(onNext: { [weak self] coordinate in
                self?.replacePin(at: coordinate)
            })
            .disposed(by: bag)
    }
    
    private func addViews() {
        guard let map = map else {
            return
        }
        view.addSubview(map)
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
        
        NSLayoutConstraint.activate(mapConstraints + locationButtonConstraints + nextButtonConstraints)
    }
    
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
        Self.logger.debug("COORDINATE: (\(coordinate.latitude), \(coordinate.longitude))")
        currentPin = pin
        map.addAnnotation(pin)
        map.setCenter(coordinate, animated: true)
    }
    
    deinit {
        if let currentPin = currentPin {
            self.map?.removeAnnotation(currentPin)
        }
        self.map?.removeOverlays(overlays)
        self.map?.showsUserLocation = false;
        self.map?.delegate = nil;
        map?.removeFromSuperview()
        self.map = nil;
        Self.logger.debug("deinit")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fetchJson()
    }
    
    
    private func fetchJson() {
        guard let map = map else {
            return
        }
        
        guard let geoJsonFileUrl = Bundle.main.url(forResource: "istanbul", withExtension: "geojson") else {
            fatalError("Error")
        }
        var geoJsonData: Data!
          do {
              geoJsonData = try Data.init(contentsOf: geoJsonFileUrl)
          } catch  {
              print(error)
          }
        
        /*
         1. geoJsonData is data type
         **/
        guard let objs = try? MKGeoJSONDecoder().decode(geoJsonData) as? [MKGeoJSONFeature] else {
            fatalError("Wrong format")
        }
        
        
        // Parse the objects
        objs.forEach { (feature) in
            guard let geometry = feature.geometry.first,
                let _ = feature.properties else {
                return;
            }
            viewModel.coordinate.accept(geometry.coordinate)
            map.setRegion(.init(center: geometry.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000), animated: true)
            if let geo = geometry as? MKOverlay {
                overlays.append(geo)
                map.addOverlay(geo)
            }
        }
    }
    
    
    private func fetchPolygonCoordinates(polygon: MKPolygon) {
        
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: polygon.pointCount)
        polygon.getCoordinates(&coords,
                               range: NSRange.init(location: 0, length: polygon.pointCount))
        var annotations = [MKPointAnnotation]()
        for coordinate in coords {
            let annotation = MKPointAnnotation.init()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        self.setAnnotations(annotations: annotations)
    }
     
}

class MapDelegate: NSObject, MKMapViewDelegate {
    
    deinit {
        print("MapDelegate \(#function)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.lineWidth =  2
            polygonView.fillColor = UIColor.green.withAlphaComponent(0.05)
            polygonView.strokeColor = UIColor.init(white: 0, alpha: 0.5)
            return polygonView
        }
        else if overlay is MKMultiPolygon {
            let multiPolygon = MKMultiPolygonRenderer(overlay: overlay)
            multiPolygon.lineWidth =  2
            multiPolygon.fillColor = UIColor.green.withAlphaComponent(0.05)
            multiPolygon.strokeColor = UIColor.init(white: 0, alpha: 0.5)
            return multiPolygon
        }
        else if overlay is MKPolyline {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.lineWidth =  2
            polylineView.strokeColor = UIColor.red
            polylineView.lineCap = .round
            return polylineView
        }
        return MKOverlayRenderer.init()
    }
}

 
 

//MARK: ==> MainView Delegate Methods
extension MapViewController {
    func setAnnotations(annotations: [MKAnnotation]) {
        guard let map = map else {
            return
        }
        map.addAnnotations(annotations)
        map.showAnnotations(map.annotations, animated: true)
    }
    
    func animateMap(to coordinates: CLLocationCoordinate2D) {
        guard let map = map else {
            return
        }
        map.setCenter(coordinates, animated: true)
    }
}

