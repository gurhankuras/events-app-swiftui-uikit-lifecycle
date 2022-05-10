//
//  SceneDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit
import SwiftUI
import SocketIO
import Combine


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private(set) static var shared: SceneDelegate?
    var window: UIWindow?
    var auth: Auth!
    var localNotifications: NotificationService!
    
    var profileFactory: ProfileViewControllerFactory!
    var chatFactory: ChatViewControllerFactory!
    var homeFactory: HomeViewControllerFactory!
    
    var appCoordinator: AppCoordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        
        localNotifications = NotificationService(notificationCenter: .current())
        
        profileFactory = ProfileViewControllerFactory()
        chatFactory = ChatViewControllerFactory()
        homeFactory = HomeViewControllerFactory()
        
        auth = makeAuth()
        auth.trySignIn()
        
        appCoordinator = AppCoordinator(homeFactory: homeFactory,
                                        chatFactory: chatFactory,
                                        profileFactory: profileFactory,
                                        auth: auth,
                                        notificationService: localNotifications)
        
        appCoordinator.window = window
        profileFactory.window = window
        
        appCoordinator.start()

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
}

