//
//  HomeViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit

struct HomeActions {
    var onEventClicked: (() -> Void)?
    var onSignClicked: (() -> Void)?
}

class HomeViewControllerFactory {

    func controller(auth: Auth, actions: HomeActions) -> UINavigationController {
        let api = EventAPIClient(client: URLSession.shared)
        let viewModel = HomeViewModel(auth: auth, api: api)
        let homeController = UINavigationController(rootView: HomeView(viewModel: viewModel))
        viewModel.onEventSelection = actions.onEventClicked
        viewModel.onSignClick = actions.onSignClicked
        configureNavigationalOptions(navigationController: homeController)
        return homeController
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.isToolbarHidden = true
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isHidden = true
    }
}
