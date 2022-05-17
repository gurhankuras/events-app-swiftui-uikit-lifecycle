//
//  MainCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class MainCoordinator: NSObject, Coordinator {
    let rootViewController = CustomUITabController()
    private var childCoordinators: [Coordinator] = []
    
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory
    private let searchFactory: SearchViewControllerFactory
    private let createFactory: EventCreationViewControllerFactory
    
    private var newEventCoordinator: NewEventCoordinator?
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         searchFactory: SearchViewControllerFactory,
         createFactory: EventCreationViewControllerFactory
    ) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.createFactory = createFactory
        self.searchFactory = searchFactory
        super.init()
    }
    
    
    func start() {

        let chatCoordinator = ChatCoordinator(factory: chatFactory)
        chatCoordinator.start()
        let chatViewController = chatCoordinator.rootViewController
        childCoordinators.append(chatCoordinator)
        
        let homeCoordinator = HomeCoordinator(factory: homeFactory)
        homeCoordinator.start()
        let homeViewController = homeCoordinator.rootViewController
        childCoordinators.append(homeCoordinator)
        
        let profileCoordinator = ProfileCoordinator(factory: profileFactory)
        profileCoordinator.start()
        let profileViewController = profileCoordinator.rootViewController
        childCoordinators.append(profileCoordinator)
        
        let searchCoordinator = SearchCoordinator(factory: searchFactory)
        searchCoordinator.start()
        let searchViewController = searchCoordinator.rootViewController
        childCoordinators.append(searchCoordinator)
        
        
        rootViewController.startNewEvent = { [weak self] in self?.handleNewEventCoordinator() }
        
        searchViewController.tabBarItem = UITabBarItem(title: "Deneme2", image: UIImage(systemName: "magnifyingglass"), tag: 1)
                
        let controllers = [homeViewController,
                           searchViewController,
                           chatViewController,
                           profileViewController]
        
        rootViewController.setViewControllers(controllers, animated: false)
    }
    
    private func handleNewEventCoordinator() {
        let coordinator = NewEventCoordinator(factory: createFactory) { [weak self] vc in
            self?.rootViewController.present(vc, animated: true)
        }
        coordinator.start()
        newEventCoordinator = coordinator
    }
}
