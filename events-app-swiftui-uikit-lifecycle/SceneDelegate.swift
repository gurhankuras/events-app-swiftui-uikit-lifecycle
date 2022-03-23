//
//  SceneDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var chatViewController: UINavigationController!
    var homeViewController: UINavigationController!
    var blankViewController: UIViewController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
       
        let tabViewController = UITabBarController()
        
        homeViewController = homeController()
        chatViewController = chatController()
        blankViewController = blankController()
        
        tabViewController.setViewControllers([homeViewController, chatViewController, blankViewController], animated: true)
        
        window?.rootViewController = tabViewController
        window?.makeKeyAndVisible()
    }
    
    func homeController() -> UINavigationController {
        let viewModel = HomeViewModel()
        let homeController = UINavigationController(rootViewController: UIHostingController(rootView: Home(viewModel: viewModel)))
        viewModel.onEventSelection = {
            homeController.pushViewController(UIHostingController(rootView: EventDetails()), animated: true)
        }
        homeController.isToolbarHidden = true
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        homeController.navigationBar.prefersLargeTitles = false
        homeController.navigationBar.isHidden = true
        return homeController
    }
    
    func chatUsersController() -> UIViewController {
        let decoratedSession = JsonGetAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let fetcher = RemoteChatUsersFetcher(network:  decoratedSession)
        let adapter = RemoteChatUsersAdapter(fetcher: fetcher)
        adapter.onSelect = { [weak self] chat in
            print("BURDA")
            self?.chatViewController.dismiss(animated: true)
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self?.chatViewController.pushViewController(vc, animated: true)
        }
        let viewModel = ChatUsersViewModel(fetcher: adapter)
        let view = ChatUsersView(viewModel: viewModel, dismiss: { [weak self] in self?.chatViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    func showChatUsers() {
        chatViewController.present(chatUsersController(), animated: true)
    }
    
    func blankController() -> UIViewController {
        let blankController = UINavigationController(rootViewController: UIHostingController(rootView: Blank()))
        blankController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        return blankController
    }
    
    func chatController() -> UINavigationController {
        let viewModel = ChatRoomsViewModel()
        let view = RecentChatsView(viewModel: viewModel) { [weak self] in self?.showChatUsers() }
        let chatController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        viewModel.onChatSelected = { [weak self] chat in
            self?.pushChatMessagesViewController(presentingController: chatController, chat: chat)
        }
        chatController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)
        chatController.navigationBar.prefersLargeTitles = false
        chatController.navigationBar.isHidden = true
        return chatController
    }
    
    func chatMessagesView(chat: RecentChatViewModel, onDismiss: @escaping () -> Void) -> UIViewController {
        let network = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let apiClient = ChatMessagesApiClient(network: network)
        let service =  RemoteChatMessageFetcher(session: .shared)
        let viewModel = ChatMessagesViewModel(for: chat, service: service, apiClient: apiClient)
        let controller = UIHostingController(rootView: ChatMessagesView(viewModel: viewModel, onDismiss: onDismiss))
        return controller
    }
    
    
    func pushChatMessagesViewController(presentingController: UINavigationController, chat: RecentChatViewModel) {
        presentingController.pushViewController(chatMessagesView(chat: chat, onDismiss: { presentingController.popViewController(animated: true)
        }), animated: true)
    }
}

