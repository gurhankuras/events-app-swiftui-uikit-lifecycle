//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation

struct PaginationOptions {
    let page: Int
    let pageSize: Int
}

extension PaginationOptions {
    public static func first(size: Int) -> Self {
        return PaginationOptions(page: 0, pageSize: size)
    }
}




class HomeViewModel: ObservableObject {
    var onSignClick: (() -> Void)?
    
    let auth: AuthService
    let locationFetcher: LocationFetcher
    let api: NearEventFinder

    @Published var user: User?
    @Published var _nearEvents: [RemoteNearEvent] = []
    
    init(auth: AuthService, api: NearEventFinder, locationFetcher: LocationFetcher) {
        self.auth = auth
        self.api = api
        self.locationFetcher = locationFetcher
        
        auth.userPublisher
            .map({result in
                switch result {
                case .loggedIn(let user):
                    return user
                case .unauthorized:
                    return nil
                case .errorOccurred(_):
                    return nil
                }
            })
            .assign(to: &$user)
        
    }
    
    var events: [RemoteNearEvent] {
        return _nearEvents
    }
    
    func loadNearEvents(completion: @escaping () -> ()) {
        locationFetcher.requestCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                let coord = location.coordinate
                let position = GeoCoordinates(latitude: coord.latitude, longitute: coord.longitude)
                self?.fetchNearEvents(position)
            case .failure(let error):
                if let error = error as? LocationServiceError {
                    switch error {
                    case .unauthorized:
                        openAppSettings()
                    }
                }
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func fetchNearEvents(_ position: GeoCoordinates) {
        api.findEvents(around: position) { [weak self] result in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self?._nearEvents = events
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    BannerService.shared.show(icon: .failure, title: error.localizedDescription, action: .close)                    
                }
                print(error.localizedDescription)
            }
        }
    }
    
    
    var isSignedIn: Bool {
        user != nil
    }
    
    func signOut() {
        auth.signOut()
    }
}
