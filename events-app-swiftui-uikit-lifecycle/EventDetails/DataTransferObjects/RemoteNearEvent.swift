//
//  RemoteNearEvent.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/14/22.
//

import Foundation
/*
protocol CommonEvent {
    var id: String { get }
    var at: Date { get }
    var image: String { get }
    var title: String { get }
    var description: String { get }
    var environment: Int { get }
    //var createdAt: Date?
    var latitude: Double { get }
    var longitute: Double { get }
    var address: CommonEventAddress { get }
    
}

protocol CommonEventAddress: Decodable {
    var city: String { get }
    var district: String { get }
    var addressLine: String? { get }
}
*/


struct RemoteNearEvent: Identifiable, Decodable {
    let id: String
    let at: Date
    let image: String?
    let title: String
    let description: String
    let environment: Int
    //let createdAt: Date?
    let latitude: Double
    let longitute: Double
    let distance: Double?
    let address: RemoteNearEventAddress
    let liveStream: RemoteLiveStreamInfo
    let categories: [String]
}

struct RemoteEvent: Identifiable, Decodable {
    let id: String
    let creatorId: String
    let at: Date
    let createdAt: Date
    let image: String
    let title: String
    let description: String
    let longitute: Double
    let latitude: Double
    let address: RemoteEventAddress
    let liveStream: LiveStream
    let environment: Int
    let categories: [String]
    
    struct LiveStream: Decodable {
        let startedAt: Date?
        let finished: Bool?
        let url: String?
    }
}

struct RemoteEventAddress: Decodable {
    let city: String
    let district: String
    let addressLine: String?
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
            liveStream: .init(startedAt: nil, finished: nil, url: nil),
            categories: []
        )
    }
}
