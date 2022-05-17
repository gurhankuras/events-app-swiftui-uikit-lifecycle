//
//  ChatViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit
import SocketIO


class ChatViewControllerFactory {
    let auth: Auth

    init(auth: Auth) {
        self.auth = auth
    }

    func controller(onChatSelected: @escaping (RoomViewModel) -> (), onStartedNewChat: @escaping () -> ()) -> UINavigationController {
        let socketManager = SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [.log(false)])
        let realTimeListener = SocketIORoomRealTimeListener(manager: socketManager, tokenStore: SecureTokenStore(keychain: .standard))
        
        let fetcher = ChatRoomFetcherStub(result: .success(ChatRoomFetcherStub.stubs))
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth, realTimeListener: realTimeListener)
        viewModel.onChatSelected = onChatSelected
        let chatController = ChatRoomsViewController(viewmodel: viewModel)
        let navController = UINavigationController(rootViewController: chatController)
        configureNavigationalOptions(navigationController: navController)
        return navController
    }
    
    func chatUsersController(onClosedUsers: @escaping () -> (), onSelectedNewChat: @escaping (ChatUser) -> ()) -> UIViewController {
        let decoratedSession = JsonGetAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let fetcher = RemoteChatUsersFetcher(network:  decoratedSession)
        let adapter = RemoteChatUsersAdapter(fetcher: fetcher)
        adapter.onSelect = onSelectedNewChat
     
        let viewModel = ChatUsersViewModel(fetcher: adapter)
        let view = ChatUsersView(viewModel: viewModel, dismiss: onClosedUsers)
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    func chatMessagesController(room: Room, onBack: @escaping () -> ()) -> UIViewController {
        let network = JsonPostAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
        let service =  RemoteChatMessageFetcher(session: .shared)
        let socketManager = SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [.log(false)])
        
        let communicator = SocketIOChatCommunicator(roomId: room.id, manager: socketManager, tokenStore: SecureTokenStore(keychain: .standard))
        
        let viewModel = ChatMessagesViewModel(for: room, service: service, auth: auth, communicator: communicator)
        let view = ChatMessagesView(viewModel: viewModel, onDismiss: onBack)
        let controller = UIHostingController(rootView: view)
        return controller
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.tabBarItem = UITabBarItem(title: "chat-tab-item".localized(), image: UIImage(systemName: "bubble.left.fill"), tag: 3)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.topViewController?.title = "chat-page-title".localized()
    }
}
