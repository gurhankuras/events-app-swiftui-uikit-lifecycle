//
//  RemoteNearEvent.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/14/22.
//

import Foundation

struct RemoteNearEvent: Identifiable, Decodable {
    let id: String
    let at: Date
    let image: String
    let title: String
    let description: String
    let createdAt: Date
    let latitude: Double
    let longitute: Double
    let distance: Double
    let address: RemoteNearEventAddress
}

struct RemoteNearEventAddress: Decodable {
    let city: String
    let district: String
    let addressLine: String?
}

extension RemoteNearEvent {
    static var stub: RemoteNearEvent {
        RemoteNearEvent(
            id: "627f864361718507a4490ab7",
            at: Date(),
            image: "",
            title: "Gercek",
            description: "Bu bir etkinliktir",
            createdAt: Date(),
            latitude: 40.885899148745175,
            longitute: 29.2455816165394,
            distance: 51.94696360946275,
            address: RemoteNearEventAddress(city: "Istanbul",
                                            district: "Kartal",
                                            addressLine: nil)
        )
    }
}
