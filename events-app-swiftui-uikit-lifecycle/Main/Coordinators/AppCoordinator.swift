//
//  AppCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory
    weak var window: UIWindow?
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(homeFactory: homeFactory, chatFactory: chatFactory, profileFactory: profileFactory)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
        window?.rootViewController = mainCoordinator.rootViewController
    }
}
