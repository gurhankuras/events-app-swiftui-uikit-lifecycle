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
    func controller(onEventClicked: @escaping (RemoteNearEvent) -> (), onSignButtonClicked: @escaping () -> ()) -> UINavigationController
}

class HomeControllerFactory: HomeViewControllerFactory {
    let auth: AuthService
    
    init(auth: AuthService) {
        self.auth = auth
    }
    
    func controller(onEventClicked: @escaping (RemoteNearEvent) -> (), onSignButtonClicked: @escaping () -> ()) -> UINavigationController {
        let store = SecureTokenStore(keychain: .standard)
        let httpClient = HttpAPIClient.shared.tokenSender(store: store)
        let api = NearEventFinder(client: httpClient)
        let locationFetcher = LocationService(manager: .init())
        let viewModel = HomeView.ViewModel(auth: auth, api: api, locationFetcher: locationFetcher)
        let homeController = UINavigationController(rootView: HomeView(viewModel: viewModel, onEventSelected: onEventClicked))
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
