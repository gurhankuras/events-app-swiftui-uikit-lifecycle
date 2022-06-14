//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation
import os
import Combine

struct PaginationOptions {
    let page: Int
    let pageSize: Int
}

extension PaginationOptions {
    public static func first(size: Int) -> Self {
        return PaginationOptions(page: 0, pageSize: size)
    }
}

extension HomeView {
    class ViewModel: ObservableObject {

        // MARK: Dependencies
        static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView.ViewModel")

        let auth: AuthService
        let locationFetcher: LocationFetcher
        let api: NearEventFinder
        let categories: [EventCategoryType] = EventCategoryType.allCases
        var onSignClick: (() -> Void)?
        var onEventSelected: ((EventCatalogCardViewModel) -> ())?

        // MARK: State
        @Published var user: User?
        @Published var events: [EventCatalogCardViewModel] = []
        @Published var loading = false
        
        var bag = Set<AnyCancellable>()
        
        init(auth: AuthService, api: NearEventFinder, locationFetcher: LocationFetcher) {
            self.auth = auth
            self.api = api
            self.locationFetcher = locationFetcher
            Self.logger.trace("HomeView.ViewModel init")
            auth.userPublisher
                .map({ result in
                    if case let .loggedIn(user) = result {
                        return user
                    }
                    return nil
                })
                .assign(to: &$user)
            
            
            $user
                .sink { [weak self] usr in
                    if let _ = usr {
                        self?.load()
                        return
                    }
                    self?.events = []
                }
                .store(in: &bag)

        }
        
        func fetch(for category: EventCategoryType) {
            
        }
        
       
        
        ///  called by init function when first loading events
        ///  controls `loading` variable in turn this controls whether show skelaton event views or not
        func load() {
            Self.logger.trace("Loads events")
            loading = true
            if self.events.isEmpty {
                self.events = Array(repeating: .init(.stub), count: 4)
            }
            self.loadNearEvents { [weak self] in
                DispatchQueue.main.async {
                    self?.loading = false
                }
            }
        }
        
        
        /// called by pull-to-refresh. The difference between `load` and this function is that
        /// when refreshing we don't want to show skelaton views
        func refresh(completion: @escaping () -> ()) {
            Self.logger.trace("Attempted refresh for events")
            loadNearEvents(completion: completion)
        }
        
        private func loadNearEvents(completion: @escaping () -> ()) {
            Self.logger.trace("Started fetching current user location.")
            locationFetcher.requestCurrentLocation { [weak self] result in
                switch result {
                case .success(let location):
                    let coord = location.coordinate
                    let position = GeoCoordinates(latitude: coord.latitude, longitute: coord.longitude)
                    Self.logger.trace("Fetched user location \(position.latitude), \(position.longitute)")
                    self?.fetchNearEvents(position, completion: completion)
                case .failure(let error):
                    if let error = error as? LocationServiceError {
                        switch error {
                        case .unauthorized:
                            Self.logger.trace("Cannot fetch users location due to not allowing permissions")
                            completion()
                            self?.setFailureState(title: "allow-location-permissions", action: .custom("allow-button-title", { openAppSettings() }))
                        }
                    }
                    Self.logger.trace("An error occured while fetching current location of user: \(error.localizedDescription)")
                }
            }
        }

        private func fetchNearEvents(_ position: GeoCoordinates, completion: @escaping () -> ()) {
            api.findEvents(around: position) { [weak self] result in
                switch result {
                case .success(let events):
                    Self.logger.trace("Fetched \(events.count) events")
                    DispatchQueue.main.async {
                        self?.events = events.map({
                            return .init($0, select: {[weak self] vm in self?.onEventSelected?(vm)})
                        })
                    }
                case .failure(let error):
                    self?.setFailureState(title: error.localizedDescription, action: .close)
                    Self.logger.trace("An error occured while fetching near events: \(error.localizedDescription)")
                }
                completion()
            }
        }
        
        private func setFailureState(title: String, action: BannerAction) {
            DispatchQueue.main.async { [weak self] in
                self?.events = []
                BannerService.shared.show(icon: .failure, title: title, action: action)
            }
        }
        
        
        
        var isSignedIn: Bool {
            user != nil
        }
        
        func signOut() {
            auth.signOut()
        }
    }
}

