//
//  EventDetailsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import MapKit
import os

extension EventDetails {
    struct ViewModel: Identifiable {
        //let event: RemoteNearEvent
        let hasLiveStream: Bool
        let latitute: Double
        let longitute: Double
        let title: String
        let id: String = UUID().uuidString
        let image: String?
        let description: String
        var watchLiveStream: (() -> ())?
        
        init(event: RemoteNearEvent, watchLiveStream: (() -> ())?) {
            self.title = event.title
            self.image = event.image
            self.description = event.description
            self.longitute = event.longitute
            self.latitute = event.latitude
            self.hasLiveStream = true
            self.watchLiveStream = watchLiveStream
        }
        
        
        var region: MKCoordinateRegion {
            let center = CLLocationCoordinate2D(latitude: latitute, longitude: longitute)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: center, span: span)
            return region
        }
        
        var users: [String] {
            ["woman", "man", "no-image"]
        }
    }
}

