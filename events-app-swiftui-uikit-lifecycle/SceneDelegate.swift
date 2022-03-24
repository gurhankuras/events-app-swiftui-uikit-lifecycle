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
    var auth: Auth!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        
        auth = makeAuth()
        auth.trySignIn()

        let tabViewController = UITabBarController()
        
        homeViewController = homeController()
        chatViewController = chatController()
        blankViewController = blankController()
        
        tabViewController.setViewControllers([homeViewController, chatViewController, blankViewController], animated: true)
        
        window?.rootViewController = tabViewController
        window?.makeKeyAndVisible()
        AppLogger.level = .debug
    }
    
    func makeAuth() -> Auth {
        let network = URLSession.shared
        let store = SecureTokenStore(keychain: .standard)
        let decoratedNetwork = JsonPostTokenSaverDecorator(decoratee: network, store: store)
        let registerer = UserSignUpAuthenticator(network: decoratedNetwork)
        let userLogin = UserSignInAuthenticator(network: decoratedNetwork)
        return Auth(registerer: registerer, userLogin: userLogin, tokenStore: store)
    }
    
    func homeController() -> UINavigationController {
        let viewModel = HomeViewModel(auth: auth)
        let homeController = UINavigationController(rootViewController: UIHostingController(rootView: Home(viewModel: viewModel)))
        viewModel.onEventSelection = {
            homeController.pushViewController(UIHostingController(rootView: EventDetails()), animated: true)
        }
        viewModel.onSignClick = { [weak self] in
            guard let self = self else { return }
            homeController.present(self.signViewController(), animated: true)
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
            guard let self = self else {
                return
            }
            
            self.chatViewController.dismiss(animated: true)
            self.chatViewController.pushViewController(self.chatMessagesView(chat: chat, onDismiss: {
                self.chatViewController.popViewController(animated: true)
            }), animated: true)
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
        let fetcher = RemoteChatRoomFetcher(network: URLSession.shared.restrictedAccess())
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth)
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
    
    func chatMessagesView(chat: ChatRepresentation, onDismiss: @escaping () -> Void) -> UIViewController {
        let network = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let apiClient = ChatMessagesApiClient(network: network)
        let service =  RemoteChatMessageFetcher(session: .shared)
        let viewModel = ChatMessagesViewModel(for: chat, service: service, apiClient: apiClient, auth: auth)
        let controller = UIHostingController(rootView: ChatMessagesView(viewModel: viewModel, onDismiss: onDismiss))
        return controller
    }
    
    func signViewController() -> UIViewController {
        let viewModel = SignupViewModel(auth: auth, didSignIn: { [weak self] in self?.homeViewController.dismiss(animated: true) })
        let view = SignView(viewModel: viewModel, dismiss: { [weak self] in self?.homeViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    
    func pushChatMessagesViewController(presentingController: UINavigationController, chat: ChatRepresentation) {
        print("PUSH")
        let controller = chatMessagesView(chat: chat, onDismiss: {
            presentingController.popViewController(animated: true)
        })
        presentingController.show(controller, sender: nil)
    }
}

