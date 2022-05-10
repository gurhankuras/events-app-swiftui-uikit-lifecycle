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
    var childCoordinators: [Coordinator] = []
    let rootViewController = TabViewController()
    
    let homeFactory: HomeViewControllerFactory
    let chatFactory: ChatViewControllerFactory
    let profileFactory: ProfileViewControllerFactory
    
    let auth: Auth
    var notificationService: NotificationService
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         auth: Auth,
         notificationService: NotificationService
    ) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.auth = auth
        self.notificationService = notificationService
    }
    
    func start() {
        let chatCoordinator = ChatCoordinator(factory: chatFactory, auth: auth)
        chatCoordinator.start()
        let chatViewController = chatCoordinator.rootViewController
        childCoordinators.append(chatCoordinator)
        
        let homeCoordinator = HomeCoordinator(factory: homeFactory, auth: auth)
        homeCoordinator.start()
        let homeViewController = homeCoordinator.rootViewController
        childCoordinators.append(homeCoordinator)
        
        let profileCoordinator = ProfileCoordinator(factory: profileFactory, notificationService: notificationService)
        profileCoordinator.start()
        let profileViewController = profileCoordinator.rootViewController
        childCoordinators.append(profileCoordinator)
        
        rootViewController.setViewControllers([homeViewController, chatViewController, profileViewController], animated: true)
    }
}
