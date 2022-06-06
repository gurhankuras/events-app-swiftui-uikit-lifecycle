//
//  AppCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit

class AppFlow: Flow {
    private var childCoordinators: [Flow] = []
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory
    private let searchFactory: SearchViewControllerFactory
    private let createFactory: EventCreationViewControllerFactory
    private let signFactory: SignViewControllerFactory
    private let authService: AuthService
    
    weak var window: UIWindow?
    
    init(homeFactory: HomeViewControllerFactory,
         chatFactory: ChatViewControllerFactory,
         profileFactory: ProfileViewControllerFactory,
         searchFactory: SearchViewControllerFactory,
         createFactory: EventCreationViewControllerFactory,
         signFactory: SignViewControllerFactory,
         authService: AuthService) {
        self.homeFactory = homeFactory
        self.chatFactory = chatFactory
        self.profileFactory = profileFactory
        self.searchFactory = searchFactory
        self.createFactory = createFactory
        self.signFactory = signFactory
        self.authService = authService

    }
    
    func start() {
        let mainCoordinator = TabFlow(homeFactory: homeFactory,
                                              chatFactory: chatFactory,
                                              profileFactory: profileFactory,
                                              searchFactory: searchFactory,
                                              createFactory: createFactory,
        signFactory: signFactory,
                                      authService: self.authService)
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
        window?.rootViewController = mainCoordinator.rootViewController
    }
}
