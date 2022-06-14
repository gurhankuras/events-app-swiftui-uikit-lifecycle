//
//  NewEventOverlayHandlingMapDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import Foundation
import MapKit
import os

class NewEventOverlayHandlingMapDelegate: NSObject, MKMapViewDelegate {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: NewEventOverlayHandlingMapDelegate.self))
    

    deinit {
        Self.logger.debug(#function)
    }
    
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
