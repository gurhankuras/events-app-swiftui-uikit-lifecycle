//
//  HomeViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit

class HomeViewControllerFactory {
    let auth: Auth
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    func controller(onEventClicked: @escaping () ->(), onSignButtonClicked: @escaping () -> ()) -> UINavigationController {
        let api = EventAPIClient(client: URLSession.shared)
        let viewModel = HomeViewModel(auth: auth, api: api)
        let homeController = UINavigationController(rootView: HomeView(viewModel: viewModel))
        viewModel.onEventSelection = onEventClicked
        viewModel.onSignClick = onSignButtonClicked
        configureNavigationalOptions(navigationController: homeController)
        return homeController
    }
    
    func signController(onClosed: @escaping () -> ()) -> UIViewController {
        let viewModel = SignupViewModel(auth: auth, didSignIn: onClosed)
        let view = SignView(viewModel: viewModel, dismiss: onClosed)
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.isToolbarHidden = true
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isHidden = true
    }
}
