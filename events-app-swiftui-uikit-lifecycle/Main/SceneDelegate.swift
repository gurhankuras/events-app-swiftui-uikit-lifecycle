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
    var chatViewController: UINavigationController!
    var homeViewController: UINavigationController!
    var blankViewController: UIViewController!
    var tabController: UITabBarController!
    var auth: Auth!
    var localNotifications: NotificationService!
    var factory: AppViewControllerFactory!
    
    var profileFactory: ProfileViewControllerFactory!
    var chatFactory: ChatViewControllerFactory!
    var homeFactory: HomeViewControllerFactory!

    var cancellable: AnyCancellable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
        
        localNotifications = NotificationService(notificationCenter: .current())
        factory = AppViewControllerFactory()
        
        profileFactory = ProfileViewControllerFactory()
        chatFactory = ChatViewControllerFactory()
        homeFactory = HomeViewControllerFactory()
        
        factory.window = window
        profileFactory.window = window
        auth = makeAuth()
        auth.trySignIn()

        setControllers()
        
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        AppLogger.level = .debug
    }

    
    func setControllers() {
        tabController = TabViewController()
        print(tabController.traitCollection.userInterfaceStyle.rawValue)
        
        setHomeController()
        setChatController()
        setProfileController()
        
        tabController.setViewControllers([homeViewController, chatViewController, blankViewController], animated: true)
    }
    
    func setHomeController() {
        var homeActions = HomeActions()
        homeActions.onSignClicked = { [weak self] in
            guard let self = self else { return }
            self.homeViewController.present(self.signViewController(), animated: true)
        }
        homeActions.onEventClicked = { [weak self] in
            guard let self = self else { return }
            self.homeViewController.pushViewController(UIHostingController(rootView: EventDetails()), animated: true)
        }
    
        homeViewController = homeFactory.controller(auth: auth, actions: homeActions)
    }
    
    func setChatController() {
        let socketManager = SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [.log(false)])
        let realTimeListener = SocketIORoomRealTimeListener(manager: socketManager, tokenStore: SecureTokenStore(keychain: .standard))
        realTimeListener.receive(completion: { [weak self] room in
            print(room)
        })
        
        var chatActions = ChatActions()
        chatActions.onStartedNewChat = {[weak self] in
            self?.showChatUsers()
        }
        chatActions.onChatSelected = { [weak self] roomVm in
            guard let self = self else { return }
            self.pushChatMessagesViewController(presentingController: self.chatViewController, room: Room(id: roomVm.id, imageUrl: roomVm.imageUrl, name: roomVm.name, message: roomVm.message, timestamp: roomVm.timestamp, lastSender: roomVm.lastSender))
        }
        
        chatViewController = chatFactory.controller(auth: auth, realTimeListener: realTimeListener, actions: chatActions)
    }
    
    func setProfileController() {
        var actions = ProfileActions()
        actions.onTropiesClicked = { [weak self] in
            self?.blankViewController.present(UIHostingController(rootView: AchievementsView()), animated: true, completion: nil)
        }
        blankViewController = profileFactory.controller(notificationService: localNotifications, actions: actions)
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
        adapter.onSelect = { [weak self] user in
            print("BURDA")
            guard let self = self else {
                return
            }
            
            let post = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
            let roomCreator = RoomCreator(network: post)
            self.cancellable = roomCreator.create(userId: user.id)
                .sink { completion in
                    
                } receiveValue: { room in
                    guard case let .loggedIn(authUser) = self.auth.userPublisher.value else {
                        return
                    }
                    
                    let roomMapper = RemoteChatRoomMapper(for: authUser)
            
                    self.chatViewController.dismiss(animated: true)
                    let remoteUser = room.lastMessage?.sender
                    let rrom = Room(id: room.id, imageUrl: room.participants.first?.image ?? "no-image", name: room.participants.first?.name ?? "-", message: room.lastMessage?.text ?? "", timestamp: Date(), lastSender: nil)
                    self.chatViewController.pushViewController(self.chatMessagesView(room: rrom, onDismiss: {
                        self.chatViewController.popViewController(animated: true)
                    }), animated: true)
                }

            
        }
        let viewModel = ChatUsersViewModel(fetcher: adapter)
        let view = ChatUsersView(viewModel: viewModel, dismiss: { [weak self] in self?.chatViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    func showChatUsers() {
        chatViewController.present(chatUsersController(), animated: true)
    }
    
    
    
    func chatMessagesView(room: Room, onDismiss: @escaping () -> Void) -> UIViewController {
        let network = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let service =  RemoteChatMessageFetcher(session: .shared)
        let socketManager = SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [.log(false)])

        let communicator = SocketIOChatCommunicator(roomId: room.id, manager: socketManager, tokenStore: SecureTokenStore(keychain: .standard))
        
        let viewModel = ChatMessagesViewModel(for: room, service: service, auth: auth, communicator: communicator)
        let controller = UIHostingController(rootView: ChatMessagesView(viewModel: viewModel, onDismiss: onDismiss))
        return controller
    }
    
    func signViewController() -> UIViewController {
        let viewModel = SignupViewModel(auth: auth, didSignIn: { [weak self] in self?.homeViewController.dismiss(animated: true) })
        let view = SignView(viewModel: viewModel, dismiss: { [weak self] in self?.homeViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    
    func pushChatMessagesViewController(presentingController: UINavigationController, room: Room) {
        print("PUSH")
        let controller = chatMessagesView(room: room, onDismiss: {
            presentingController.popViewController(animated: true)
        })
        presentingController.show(controller, sender: nil)
    }
    
    
}

