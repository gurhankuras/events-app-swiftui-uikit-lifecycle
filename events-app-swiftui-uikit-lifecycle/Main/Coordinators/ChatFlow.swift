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

class ChatFlow: Flow {
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    private let factory: ChatViewControllerFactory
    private var cancellable: AnyCancellable?
    private let authService: AuthService
    init(factory: ChatViewControllerFactory, authService: AuthService) {
        self.factory = factory
        self.authService = authService
    }
    
    func start() {
        rootViewController = factory.controller(onChatSelected: { [weak self] roomVm in
            guard let self = self else { return }
            // TODO: move to mapper
            let room = Room(id: roomVm.id, imageUrl: roomVm.imageUrl, name: roomVm.name, message: roomVm.message, timestamp: roomVm.timestamp, lastSender: roomVm.lastSender)
            self.openChat(for: room)
        }, onStartedNewChat: {[weak self] in
            self?.showChatUsers()
        }, onSign: { [weak self] in
            
            guard let self = self else { return }
            let vc = SignViewControllerFactory(authService: self.authService).controller(onClosed: {
                self.rootViewController.dismiss(animated: true)
            })
            
            self.rootViewController.present(vc, animated: true)
        })
    }
    
    private func openChat(for room: Room) {
        let vc = factory.chatMessagesController(room: room, onBack:  { [weak self] in self?.closeChat() })
        rootViewController.show(vc, sender: nil)
    }
    
    private func closeChat() {
        self.rootViewController.popViewController(animated: true)
    }
    
    private func showChatUsers() {
        let vc = factory.chatUsersController(onClosedUsers: { [weak self] in self?.dismissStartingNewChat() },
                                             onSelectedNewChat: { [weak self] user in self?.startNewChat(with: user) })
        self.rootViewController.present(vc, animated: true)
    }
    
    private func dismissStartingNewChat() {
        rootViewController.dismiss(animated: true)
    }
    
    // TODO: move logic
    private func startNewChat(with user: ChatUser) {
        //{ [weak self] user in
            /*
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
*/
            
       // }
    }
}

