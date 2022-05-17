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
    private let searchFactory: SearchViewControllerFactory
    private let createFactory: EventCreationViewControllerFactory
    
    weak var window: UIWindow?
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         searchFactory: SearchViewControllerFactory,
         createFactory: EventCreationViewControllerFactory) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.searchFactory = searchFactory
        self.createFactory = createFactory
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(homeFactory: homeFactory,
                                              chatFactory: chatFactory,
                                              profileFactory: profileFactory,
                                              searchFactory: searchFactory,
                                              createFactory: createFactory)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
        window?.rootViewController = mainCoordinator.rootViewController
    }
}
