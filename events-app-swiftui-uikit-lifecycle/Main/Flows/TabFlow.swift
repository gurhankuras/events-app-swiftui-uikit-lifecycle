//
//  MainCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class TabFlow: NSObject, Flow {
    var rootViewController: UITabBarController!
    private var childCoordinators: [Flow] = []
    
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory
    private let searchFactory: SearchViewControllerFactory
    private let createFactory: EventCreationViewControllerFactory
    private let signFactory: SignViewControllerFactory
    
    private var newEventCoordinator: NewEventFlow?
    private let authService: AuthService
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         searchFactory: SearchViewControllerFactory,
         createFactory: EventCreationViewControllerFactory,
         signFactory: SignViewControllerFactory,
         authService: AuthService
    ) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.createFactory = createFactory
        self.searchFactory = searchFactory
        self.signFactory = signFactory
        self.authService = authService
        super.init()
    }
    
    func start() {
        let homeCoordinator = HomeFlow(factory: homeFactory, signFactory: signFactory)
        homeCoordinator.start()
        let homeViewController = homeCoordinator.rootViewController!
        childCoordinators.append(homeCoordinator)
        
        let searchCoordinator = SearchFlow(factory: searchFactory)
        searchCoordinator.start()
        let searchViewController = searchCoordinator.rootViewController
        childCoordinators.append(searchCoordinator)
        
        let chatCoordinator = ChatFlow(factory: chatFactory, authService: authService)
        chatCoordinator.start()
        let chatViewController = chatCoordinator.rootViewController
        childCoordinators.append(chatCoordinator)
        
        let profileCoordinator = ProfileFlow(factory: profileFactory)
        profileCoordinator.start()
        let profileViewController = profileCoordinator.rootViewController
        childCoordinators.append(profileCoordinator)
        
        searchViewController.tabBarItem = UITabBarItem(title: "search-tab-item".localized(), image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let controllers = [homeViewController, searchViewController,
                           chatViewController, profileViewController]
        
        configureTabController(with: controllers)
    }
}

// MARK: Create New Event Tab
extension TabFlow {
    private func configureTabController(with controllers: [UINavigationController]) {
        let delegate = TabbarDelegate(authService: self.authService)
        delegate.onNewEventTabSelected = { [weak self] authenticated in
            guard let self = self else { return }
            if authenticated {
                self.handleNewEventCoordinator()
                return
            }
            self.presentSigningPage()
            
        }
        rootViewController = CustomUITabController(delegate: delegate)
        rootViewController.setViewControllers(controllers, animated: false)
    }
    
    private func handleNewEventCoordinator() {
        let coordinator = NewEventFlow(factory: createFactory) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.rootViewController.present(vc, animated: true)
        } close: { [weak self] in
            self?.rootViewController.dismiss(animated: true)
            self?.newEventCoordinator = nil
        }
        coordinator.start()
        newEventCoordinator = coordinator
    }
    
    private func presentSigningPage() {
        let vc = self.signFactory.controller(onClosed: {
            self.rootViewController.dismiss(animated: true)
        })
        self.rootViewController.present(vc, animated: true)
    }
}
