//
//  ViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/25/22.
//

import Foundation
import UIKit
import SwiftUI

protocol ViewControllerFactory {
    func homeController(auth: Auth, onEventSelection: @escaping () -> Void, onSignClick: @escaping () -> Void) -> UINavigationController
    func blankController(notificationService: NotificationService) -> UIViewController
    func chatController(auth: Auth, onStartNewChat: @escaping () -> Void, onChatSelected: @escaping (ChatRepresentation) -> Void) -> UINavigationController
    
}

class AppViewControllerFactory: ViewControllerFactory {
    func homeController(auth: Auth, onEventSelection: @escaping () -> Void, onSignClick: @escaping () -> Void) -> UINavigationController {
        let viewModel = HomeViewModel(auth: auth)
        let homeController = UINavigationController(rootViewController: UIHostingController(rootView: Home(viewModel: viewModel)))
        viewModel.onEventSelection = onEventSelection
        viewModel.onSignClick = onSignClick
        homeController.isToolbarHidden = true
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        homeController.navigationBar.prefersLargeTitles = false
        homeController.navigationBar.isHidden = true
        return homeController
    }
    
    func blankController(notificationService: NotificationService) -> UIViewController {
        let blankController = UINavigationController(rootViewController: UIHostingController(rootView: Blank(notificationService: notificationService)))
        blankController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        return blankController
    }
    
    func chatController(auth: Auth, onStartNewChat: @escaping () -> Void, onChatSelected: @escaping (ChatRepresentation) -> Void) -> UINavigationController {
        let fetcher = RemoteChatRoomFetcher(network: URLSession.shared.restrictedAccess())
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth)
        viewModel.onChatSelected = onChatSelected
        let view = RoomsView(viewModel: viewModel, onStartNewChat: onStartNewChat)
        let chatController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        
        
        chatController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)
        chatController.navigationBar.prefersLargeTitles = false
        chatController.navigationBar.isHidden = true
        return chatController
    }
}
