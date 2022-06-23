//
//  HomeViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit

protocol HomeViewControllerFactory {
    func controller(onEventClicked: @escaping (EventCatalogCardViewModel) -> (), onSignButtonClicked: @escaping () -> ()) -> UINavigationController
}

class HomeControllerFactory: HomeViewControllerFactory {
    let auth: AuthService
    
    init(auth: AuthService) {
        self.auth = auth
    }
    
    func controller(onEventClicked: @escaping (EventCatalogCardViewModel) -> (), onSignButtonClicked: @escaping () -> ()) -> UINavigationController {
        let store = SecureTokenStore(keychain: .standard)
        let httpClient = HttpAPIClient.shared.tokenSender(store: store)
        let api = NearEventFinder(client: httpClient)
        let locationFetcher = LocationService(manager: .init())
        let eventService = EventFetcher(client: httpClient)
        
        let recentEventsViewModel = RecentEventsViewModel(eventService: eventService)
        let nearEventsViewModel = NearEventsViewModel(locationFetcher: locationFetcher, api: api)
        let viewModel = HomeView.ViewModel(auth: auth,
                                           recentEventsViewModel: recentEventsViewModel,
                                           nearEventsViewModel: nearEventsViewModel)
        
        recentEventsViewModel.onEventSelected = onEventClicked
        nearEventsViewModel.onEventSelected = onEventClicked
        
        let homeController = UINavigationController(rootView: HomeView(viewModel: viewModel))
        viewModel.onSignClick = onSignButtonClicked
        configureNavigationalOptions(navigationController: homeController)
        return homeController
    }
    
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.isToolbarHidden = true
        navigationController.tabBarItem = UITabBarItem(title: "home-tab-item".localized(), image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isHidden = true
    }
}
