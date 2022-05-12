//
//  MainCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class MainCoordinator: Coordinator {
    let rootViewController = UITabBarController()
    private var childCoordinators: [Coordinator] = []
    
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory

    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory
    ) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
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
        
        rootViewController.setViewControllers([homeViewController, chatViewController, profileViewController], animated: true)
    }
}
