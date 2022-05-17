//
//  MapViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    var map: MKMapView = MKMapView()
    private var centerCoordinate = CLLocationCoordinate2D.init(latitude: 40.986, longitude: 29.283)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpMapView()
        view.addSubview(map)
        map.delegate = self
        let region = MKCoordinateRegion.init(center: self.centerCoordinate,
                                             latitudinalMeters: CLLocationDistance.init(500),
                                             longitudinalMeters: CLLocationDistance.init(500))
        map.setRegion(region, animated: true)
        map.setCenter(centerCoordinate, animated: true)
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fetchJson()
    }
    
    
    private func fetchJson() {
        guard let geoJsonFileUrl = Bundle.main.url(forResource: "tr-cities", withExtension: "geojson"),
            let geoJsonData = try? Data.init(contentsOf: geoJsonFileUrl) else {
                fatalError("Failure to fetch the file.")
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
                let propData = feature.properties else {
                return;
            }
            
            
            if let geo = geometry as? MKOverlay {
                self.map.addOverlay(geo)
            }
            
            /*
            if let polygon = geometry as? MKPolygon {
                self.map.addOverlay(polygon)
            }
            
            if let polyline = geometry as? MKPolyline {
                self.map.addOverlay(polyline)
            }
             */
            
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


//MARK: ==> MainView Delegate Methods
extension MapViewController {
    func setUpMapView() {
        self.map = MKMapView()
        let region = MKCoordinateRegion.init(center: self.centerCoordinate,
                                             latitudinalMeters: CLLocationDistance.init(500),
                                             longitudinalMeters: CLLocationDistance.init(500))
        self.map.setRegion(region, animated: true)
        self.view.addSubview(self.map)
        self.map.delegate = self
    }
    
    func setAnnotations(annotations: [MKAnnotation]) {
        self.map.addAnnotations(annotations)
        self.map.showAnnotations(self.map.annotations, animated: true)
    }
    
    func animateMap(to coordinates: CLLocationCoordinate2D) {
        self.map.setCenter(coordinates, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.lineWidth =  2
            polygonView.fillColor = UIColor.green.withAlphaComponent(0.25)
            polygonView.strokeColor = UIColor.init(white: 0, alpha: 0.5)
            return polygonView
        }
        else if overlay is MKMultiPolygon {
            let multiPolygon = MKMultiPolygonRenderer(overlay: overlay)
            multiPolygon.lineWidth =  2
            multiPolygon.fillColor = UIColor.green.withAlphaComponent(0.25)
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
