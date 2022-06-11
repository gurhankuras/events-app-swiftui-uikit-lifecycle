//
//  EventCatalogCardViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/11/22.
//

import Foundation

struct EventCatalogCardViewModel: Identifiable {
    private var onSelected: ((EventCatalogCardViewModel) -> ())?
    private let _address: RemoteNearEventAddress
    private let isOnline: Bool = true
    let event: RemoteNearEvent
    var isFavorite: Bool = false
    
    init(_ event: RemoteNearEvent, select: ((EventCatalogCardViewModel) -> ())?) {
        self._address = event.address
        self.event = event
        self.onSelected = select
    }
    
    init(_ event: RemoteNearEvent) {
        self.init(event, select: nil)
    }
    
    
    var id: String {
        event.id
    }
    
    var startsAt: String {
        "25 March 2022\n06.00 PM"
    }
    
    var address: String {
        if isOnline {
            return "Online"
        }
        return "\(_address.district) / \(_address.city)"
    }
    
    var image: String {
        return event.image
    }
    
    var title: String {
        return event.title
    }
    
    var distance: String {
        return "~\(Int(round(event.distance)))m"
    }

    func select() {
        print("selected")
        onSelected?(self)
    }
    
}
