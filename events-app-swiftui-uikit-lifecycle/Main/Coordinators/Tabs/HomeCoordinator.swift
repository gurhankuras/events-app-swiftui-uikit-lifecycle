//
//  HomeCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class HomeCoordinator: Coordinator {
    let factory: HomeViewControllerFactory
    let auth: Auth
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    
    init(factory: HomeViewControllerFactory, auth: Auth) {
        self.auth = auth
        self.factory = factory
    }
    
   
    
    func start() {
        setHomeController()
    }
    
    func setHomeController() {
        var homeActions = HomeActions()
        homeActions.onSignClicked = { [weak self] in
            guard let self = self else { return }
            self.rootViewController.present(self.signViewController(), animated: true)
        }
        homeActions.onEventClicked = { [weak self] in
            guard let self = self else { return }
            self.rootViewController.pushViewController(UIHostingController(rootView: EventDetails()), animated: true)
        }
        rootViewController = factory.controller(auth: auth, actions: homeActions)
    }
    
    func signViewController() -> UIViewController {
        let viewModel = SignupViewModel(auth: auth, didSignIn: { [weak self] in self?.rootViewController.dismiss(animated: true) })
        let view = SignView(viewModel: viewModel, dismiss: { [weak self] in self?.rootViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    
}
