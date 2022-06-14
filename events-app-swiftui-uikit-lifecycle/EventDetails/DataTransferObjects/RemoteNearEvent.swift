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
    let environment: Int
    //let createdAt: Date?
    let latitude: Double
    let longitute: Double
    let distance: Double
    let address: RemoteNearEventAddress
    let liveStream: RemoteLiveStreamInfo
}

struct RemoteLiveStreamInfo: Decodable {
    let startedAt: Date?
    let finished: Bool?
    let url: String?
}

struct RemoteNearEventAddress: Decodable {
    let city: String
    let district: String
    let addressLine: String?
}

extension RemoteNearEvent {
    private static var randomId: String {
        return "\(UUID().uuidString)\(UUID().uuidString.randomElement()!)"
    }
    static var stub: RemoteNearEvent {
        RemoteNearEvent(
            id: randomId,
            at: Date(),
            image: "",
            title: "Xxxxxxxxx xxxxxxxxxx xxxxxxxx xxxxxx",
            description: "Xx xxx xxxxxxxxxxxxxx",
            environment: 0,
            //createdAt: nil,
            latitude: 40.885899148745175,
            longitute: 29.2455816165394,
            distance: 51.94696360946275,
            address: RemoteNearEventAddress(city: "Xxxxxxx",
                                            district: "Xxxxxx",
                                            addressLine: nil),
            liveStream: .init(startedAt: nil, finished: nil, url: nil)
        )
    }
}
