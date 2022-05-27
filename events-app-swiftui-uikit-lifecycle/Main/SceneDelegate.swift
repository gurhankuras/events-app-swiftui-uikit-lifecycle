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
    
    var appCoordinator: AppCoordinator!
    
    var deleteThis: UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        AppLogger.level = .debug

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        UIApplication.shared.dismissKeyboardWhenClickedOutside()
        /*
        initSharedDependencies()
        initFactories()
        
        appCoordinator = AppCoordinator(homeFactory: homeFactory, chatFactory: chatFactory,
                                        profileFactory: profileFactory, searchFactory: searchFactory,
                                        createFactory: createFactory, signFactory: signFactory)
        
        appCoordinator.window = window
        
        auth.trySignIn()
        appCoordinator.start()
         */
        deleteThis = UINavigationController(rootView: BillingAddressStepView(onClickedNext: { [weak self]  previousStep in self?.showCreditCardForm(with: previousStep) }))
        window?.rootViewController = deleteThis
        window?.makeKeyAndVisible()
    }
    
    // TODO: Move to a coordinator
    private func showCreditCardForm(with previousStep: BillingAddressStep) {
        let viewModel = CreditCardFormViewModel(billingAddressStep: previousStep)
        let view = CreditCardStepView(viewModel: viewModel, onNext: { [weak self] content in self?.showCheckout(htmlContent: content) })
        self.deleteThis.pushViewController(UIHostingController(rootView: view), animated: true)
    }
    
    private func showCheckout(htmlContent: String) {
        DispatchQueue.main.async { [weak self] in
            let view = CheckoutWebView(htmlContent: htmlContent, completion: {
                self?.deleteThis.popToRootViewController(animated: true)
            })
            let vc = UIHostingController(rootView: view)
            self?.deleteThis.pushViewController(vc, animated: true)
        }
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

