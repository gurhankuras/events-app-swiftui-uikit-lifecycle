//
//  SceneDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private(set) static var shared: SceneDelegate?
    var window: UIWindow?
    
    var auth: AuthService!
    var localNotifications: NotificationService!
    
    var profileFactory: ProfileViewControllerFactory!
    var chatFactory: ChatViewControllerFactory!
    var homeFactory: HomeViewControllerFactory!
    var createFactory: EventCreationViewControllerFactory!
    var searchFactory: SearchViewControllerFactory!
    var signFactory: SignViewControllerFactory!
    
    var appCoordinator: AppFlow!
    
    var deleteThis: UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        AppLogger.level = .debug

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        UIApplication.shared.dismissKeyboardWhenClickedOutside()
        initSharedDependencies()
        initFactories()
        
        appCoordinator = AppFlow(homeFactory: homeFactory, chatFactory: chatFactory,
                                        profileFactory: profileFactory, searchFactory: searchFactory,
                                        createFactory: createFactory, signFactory: signFactory)
        
        appCoordinator.window = window
        
        
        auth.trySignIn()
        appCoordinator.start()
         
        /*
        let viewModel = LinkedInVerificationViewModel()
        viewModel.didVerified = { [weak self] in
            DispatchQueue.main.async {
                self?.deleteThis.popViewController(animated: true)                
            }
        }
        deleteThis = UINavigationController(rootView: LinkedInView(viewModel: viewModel))
        window?.rootViewController = deleteThis
         */
        window?.makeKeyAndVisible()
    }
    
    
    
    private func initSharedDependencies() {
        localNotifications = NotificationService(notificationCenter: .current())
        auth = makeAuth()
    }
    
    private func initFactories() {
        profileFactory = ProfileViewControllerFactory(notificationService: localNotifications)
        chatFactory = AuthenticatedChatViewControllerFactory(auth: auth)
        homeFactory = HomeViewControllerFactory(auth: auth)
        searchFactory = SearchViewControllerFactory()
        createFactory = EventCreationViewControllerFactory()
        signFactory = SignViewControllerFactory(authService: auth)
        chatFactory.signController = { [weak signFactory] _ in (signFactory?.controller(onClosed: {}))! }
    }
    
    private func makeAuth() -> AuthService {
        let store = SecureTokenStore(keychain: .standard)
        let signUp = UserSignUp(client: HttpAPIClient.shared)
        let httpClient = HttpAPIClient.shared.tokenSaver(store: store)
        let signIn = UserSignIn(client: httpClient)
        return AuthService(signUp: signUp, signIn: signIn, tokenStore: store)
    }
}

