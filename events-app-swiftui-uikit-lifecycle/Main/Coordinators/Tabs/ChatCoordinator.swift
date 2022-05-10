//
//  ChatCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI
import SocketIO
import Combine

class ChatCoordinator: Coordinator {
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    
    let factory: ChatViewControllerFactory
    let auth: Auth
    var cancellable: AnyCancellable?

    init(factory: ChatViewControllerFactory, auth: Auth) {
        self.factory = factory
        self.auth = auth
    }
    
    func start() {
        setChatController()
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
            self.pushChatMessagesViewController(presentingController: self.rootViewController, room: Room(id: roomVm.id, imageUrl: roomVm.imageUrl, name: roomVm.name, message: roomVm.message, timestamp: roomVm.timestamp, lastSender: roomVm.lastSender))
        }
        
        rootViewController = factory.controller(auth: auth, realTimeListener: realTimeListener, actions: chatActions)
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
            
                    self.rootViewController.dismiss(animated: true)
                    let remoteUser = room.lastMessage?.sender
                    let rrom = Room(id: room.id, imageUrl: room.participants.first?.image ?? "no-image", name: room.participants.first?.name ?? "-", message: room.lastMessage?.text ?? "", timestamp: Date(), lastSender: nil)
                    self.rootViewController.pushViewController(self.chatMessagesView(room: rrom, onDismiss: {
                        self.rootViewController.popViewController(animated: true)
                    }), animated: true)
                }

            
        }
        let viewModel = ChatUsersViewModel(fetcher: adapter)
        let view = ChatUsersView(viewModel: viewModel, dismiss: { [weak self] in self?.rootViewController.dismiss(animated: true) })
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    func showChatUsers() {
        rootViewController.present(chatUsersController(), animated: true)
    }
    
    func pushChatMessagesViewController(presentingController: UINavigationController, room: Room) {
        print("PUSH")
        let controller = chatMessagesView(room: room, onDismiss: {
            presentingController.popViewController(animated: true)
        })
        presentingController.show(controller, sender: nil)
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
}
