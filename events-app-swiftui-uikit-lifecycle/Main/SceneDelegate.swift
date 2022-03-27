//
//  SceneDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit
import SwiftUI
import SocketIO

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var chatViewController: UINavigationController!
    var homeViewController: UINavigationController!
    var blankViewController: UIViewController!
    var tabController: UITabBarController!
    var auth: Auth!
    var localNotifications: NotificationService!
    var factory: ViewControllerFactory!
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        
        localNotifications = NotificationService(notificationCenter: .current())
        factory = AppViewControllerFactory()

        auth = makeAuth()
        auth.trySignIn()

        setControllers()
        
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        AppLogger.level = .debug
    }
    
    func setControllers() {
        tabController = UITabBarController()
        
        homeViewController = factory.homeController(auth: auth, onEventSelection: { [weak self] in
            guard let self = self else { return }
            self.homeViewController.pushViewController(UIHostingController(rootView: EventDetails()), animated: true)
        }, onSignClick: { [weak self] in
                guard let self = self else { return }
                self.homeViewController.present(self.signViewController(), animated: true)
        })
        
        chatViewController = factory.chatController(auth: auth, onStartNewChat: {[weak self] in
            self?.showChatUsers()
        }, onChatSelected: { [weak self] chatRepresentation in
            guard let self = self else { return }
            self.pushChatMessagesViewController(presentingController: self.chatViewController, chat: chatRepresentation)
        })
        
        blankViewController = factory.blankController(notificationService: localNotifications)
        tabController.setViewControllers([homeViewController, chatViewController, blankViewController], animated: true)
    }
    
    
    func makeAuth() -> Auth {
        let network = URLSession.shared
        let store = SecureTokenStore(keychain: .standard)
        let decoratedNetwork = JsonPostTokenSaverDecorator(decoratee: network, store: store)
        let registerer = UserSignUpAuthenticator(network: decoratedNetwork)
        let userLogin = UserSignInAuthenticator(network: decoratedNetwork)
        return Auth(registerer: registerer, userLogin: userLogin, tokenStore: store)
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
    
    
    
    func chatMessagesView(chat: ChatRepresentation, onDismiss: @escaping () -> Void) -> UIViewController {
        let network = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let apiClient = ChatMessagesApiClient(network: network)
        let service =  RemoteChatMessageFetcher(session: .shared)
        let manager =  SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [.log(false)])
        
        let communicator = SocketIOChatCommunicator(roomId: chat.roomId ?? "", manager: manager, tokenStore: SecureTokenStore(keychain: .standard))
        
        let viewModel = ChatMessagesViewModel(for: chat, service: service, apiClient: apiClient, auth: auth, communicator: communicator)
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

