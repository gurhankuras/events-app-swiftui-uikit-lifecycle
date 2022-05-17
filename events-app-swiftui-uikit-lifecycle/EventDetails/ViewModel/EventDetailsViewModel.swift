//
//  EventDetailsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import MapKit

struct EventDetailsViewModel {
    let nearEvent: RemoteNearEvent
    
    var region: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: nearEvent.latitude, longitude: nearEvent.longitute)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }
    
    var users: [String] {
        ["concert", "concert", "concert"]
    }
}
