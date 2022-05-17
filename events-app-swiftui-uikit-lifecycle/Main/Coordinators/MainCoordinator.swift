//
//  MainCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class MainCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    let rootViewController = UITabBarController()
    private var childCoordinators: [Coordinator] = []
    
    private let homeFactory: HomeViewControllerFactory
    private let chatFactory: ChatViewControllerFactory
    private let profileFactory: ProfileViewControllerFactory
    private let searchFactory: SearchViewControllerFactory
    private let createFactory: EventCreationViewControllerFactory
    
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
        rootViewController.delegate = self

    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController.title == "Deneme" {
            let vc = createFactory.controller()
            ///vc.view.backgroundColor = .black
            rootViewController.present(vc, animated: true)
            return false
        }
        return true
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
        
        let vc = UIViewController()
        vc.title = "Deneme"
        let image = UIImage(systemName: "plus.circle")
     
        vc.tabBarItem = UITabBarItem(title: "Deneme", image: image, tag: 2)
        searchViewController.tabBarItem = UITabBarItem(title: "Deneme2", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        rootViewController.setViewControllers([homeViewController, searchViewController, vc,
                                               chatViewController, profileViewController], animated: false)
        
        /*
        for item in rootViewController.tabBar.items! {
            if item.title == "Deneme" {
                item.title = nil
                item.imageInsets = UIEdgeInsets(top: 6.0, left: 0, bottom: 0, right: 0)
            }
        }
        */
        //guard let items = rootViewController.tabBar.items,
        //      let createTab = items. else {
        //          return
        //      }
        //vc.tabBarItem.isEnabled = false
    }
    
    /*
    private func configureNavigationalOptions(navigationController: UIViewController) {
        navigationController.isToolbarHidden = true
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isHidden = true
    }
     */
}
