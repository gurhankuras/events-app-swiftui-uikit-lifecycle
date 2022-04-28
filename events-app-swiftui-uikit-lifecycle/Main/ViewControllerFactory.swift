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
    func chatController(auth: Auth, realTimeListener: RoomRealTimeListener, onStartNewChat: @escaping () -> Void, onChatSelected: @escaping (RoomViewModel) -> Void) -> UINavigationController
    
}

class AppViewControllerFactory: ViewControllerFactory {
    public weak var window: UIWindow?
    
    func homeController(auth: Auth, onEventSelection: @escaping () -> Void, onSignClick: @escaping () -> Void) -> UINavigationController {
        let viewModel = HomeViewModel(auth: auth, api: .init(client: URLSession.shared))
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
        let darkModeSettings = DarkModeSettings(window: window)
        let settingsViewModel = SettingsViewModel(darkModeSettings: darkModeSettings)
        let blankController = UINavigationController(rootViewController: UIHostingController(rootView: ProfileView(settingsViewModel: settingsViewModel)))
        //UINavigationController(rootViewController: UIHostingController(rootView: Blank(notificationService: notificationService)))
        blankController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        return blankController
    }
    
    func chatController(auth: Auth, realTimeListener: RoomRealTimeListener, onStartNewChat: @escaping () -> Void, onChatSelected: @escaping (RoomViewModel) -> Void) -> UINavigationController {
        /*
        let fetcher = RemoteChatRoomFetcher(network: URLSession.shared.restrictedAccess())
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth, realTimeListener: realTimeListener)
        viewModel.onChatSelected = onChatSelected
        let view = RoomsView(viewModel: viewModel, onStartNewChat: onStartNewChat)
        let chatController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        
        
        chatController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)
        chatController.navigationBar.prefersLargeTitles = false
        chatController.navigationBar.isHidden = true
        return chatController
         */
        //let fetcher = RemoteChatRoomFetcher(network: URLSession.shared.restrictedAccess())
        let fetcher = ChatRoomFetcherStub(result: .success(ChatRoomFetcherStub.stubs)
        )
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth, realTimeListener: realTimeListener)
        viewModel.onChatSelected = onChatSelected
        let chatController = ChatRoomsViewController(viewmodel: viewModel)
        let navController = UINavigationController(rootViewController: chatController)
        navController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)

        navController.navigationBar.prefersLargeTitles = false
        chatController.title = "Chats"
        //navController.navigationBar.isHidden = true
        return navController
    }
    
}
