//
//  AppCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let homeFactory: HomeViewControllerFactory
    let chatFactory: ChatViewControllerFactory
    let profileFactory: ProfileViewControllerFactory
    let auth: Auth
    let notificationService: NotificationService
    weak var window: UIWindow?
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         auth: Auth,
         notificationService: NotificationService) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.auth = auth
        self.notificationService = notificationService
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(homeFactory: homeFactory, chatFactory: chatFactory, profileFactory: profileFactory, auth: auth, notificationService: notificationService)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
        window?.rootViewController = mainCoordinator.rootViewController
    }
}
