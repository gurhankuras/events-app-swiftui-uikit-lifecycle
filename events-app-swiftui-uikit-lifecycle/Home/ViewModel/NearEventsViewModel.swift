//
//  NearEventsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/15/22.
//

import Foundation
import os

class NearEventsViewModel: ObservableObject {
    init(locationFetcher: LocationFetcher, api: NearEventFinder, onEventSelected: ((EventCatalogCardViewModel) -> ())? = nil) {
        self.locationFetcher = locationFetcher
        self.api = api
        self.onEventSelected = onEventSelected
    }
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: NearEventsViewModel.self))
    
    let locationFetcher: LocationFetcher
    let api: NearEventFinder

    @Published var nearEvents: [EventCatalogCardViewModel] = []
    @Published var nearEventsLoading = false
    var onEventSelected: ((EventCatalogCardViewModel) -> ())?
    
    func loadNearEvents() {
        Self.logger.trace("Started fetching current user location.")
        nearEventsLoading = true
        locationFetcher.requestCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                let coord = location.coordinate
                let position = GeoCoordinates(latitude: coord.latitude, longitute: coord.longitude)
                Self.logger.trace("Fetched user location \(position.latitude), \(position.longitute)")
                self?.fetchNearEvents(position)
            case .failure(let error):
                if let error = error as? LocationServiceError {
                    switch error {
                    case .unauthorized:
                        Self.logger.trace("Cannot fetch users location due to not allowing permissions")
                        //completion()
                        self?.setFailureState(title: "allow-location-permissions", action: .custom("allow-button-title", { openAppSettings() }))
                    }
                }
                DispatchQueue.main.async {
                    self?.nearEventsLoading = false
                }
                Self.logger.trace("An error occured while fetching current location of user: \(error.localizedDescription)")
            }
        }
    }

    private func fetchNearEvents(_ position: GeoCoordinates) {
        api.findEvents(around: position) { [weak self] result in
            switch result {
            case .success(let events):
                Self.logger.trace("Fetched \(events.count) events")
                DispatchQueue.main.async {
                    self?.nearEvents = events.map({
                        return .init($0, select: {[weak self] vm in self?.onEventSelected?(vm)})
                    })
                }
            case .failure(let error):
                self?.setFailureState(title: error.localizedDescription, action: .close)
                Self.logger.trace("An error occured while fetching near events: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.nearEventsLoading = false
            }
        }
    }
    
    private func setFailureState(title: String, action: BannerAction) {
        DispatchQueue.main.async { [weak self] in
            self?.nearEvents = []
            BannerService.shared.show(icon: .failure, title: title, action: action)
        }
    }
}
