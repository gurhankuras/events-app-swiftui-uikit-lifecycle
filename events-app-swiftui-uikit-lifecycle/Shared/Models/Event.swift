//
//  Event.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import Foundation


struct Event: Identifiable {
    let id: String
    let title: String
    let address: String
    let date: Date
    let image: String
    var select: (() -> Void)?
}


extension Event {
    static var fake: Event {
        Event(id: UUID().uuidString, title: "Techno Fair 2020", address: "Hilton, San Fransisco", date: Date.init(), image: "deneme", select: nil)
    }
    
    static func fakes(repeat count: Int) -> [Event] {
        let event = fake
        return (1..<count).map { _ in
            return Event(id: UUID().uuidString, title: event.title, address: event.address, date: event.date, image: event.image, select: nil)
        }
    }
}
