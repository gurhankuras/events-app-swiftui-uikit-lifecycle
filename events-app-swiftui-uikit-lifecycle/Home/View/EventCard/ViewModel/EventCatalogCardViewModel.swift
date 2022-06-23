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
    private let isOnline: Bool
    let event: RemoteNearEvent
    var isFavorite: Bool = false
    
    init(_ event: RemoteNearEvent, select: ((EventCatalogCardViewModel) -> ())?) {
        self._address = event.address
        self.event = event
        self.isOnline = event.environment != 0
        self.onSelected = select
    }
    
    /*
    init(_ event: RemoteEvent, select: ((EventCatalogCardViewModel) -> ())?) {
        self._address = event.address
        self.event = event
        self.isOnline = event.environment != 0
        self.onSelected = select
    }
     */
    
    init(_ event: RemoteNearEvent) {
        self.init(event, select: nil)
    }
    
    var streaming: Bool {
        guard let liveStreamStartDate = event.liveStream.startedAt else {
            return false
        }
        let now = Date()
        return liveStreamStartDate < now
    }
    
    var id: String {
        event.id
    }
    
    var startsAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: event.at) ?? "-"
    }
    
    var address: String {
        if isOnline {
            return "Online"
        }
        var district = _address.district.isEmpty ? "-" : _address.district
        return "\(district) / \(_address.city)"
    }
    
    var image: String {
        return event.image ?? ""
    }
    
    var title: String {
        return event.title
    }
    
    var distance: String? {
        guard let distance = event.distance else {
            return nil
        }
        return "~\(Int(round(distance)))m"
    }

    func select() {
        print("selected")
        onSelected?(self)
    }
    
}
