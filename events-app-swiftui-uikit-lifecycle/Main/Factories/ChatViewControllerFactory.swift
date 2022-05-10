//
//  ChatViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit



struct ChatActions {
    var onStartedNewChat: (() -> Void)?
    var onChatSelected: ((RoomViewModel) -> Void)?
}

class ChatViewControllerFactory {

    func controller(auth: Auth, realTimeListener: RoomRealTimeListener, actions: ChatActions) -> UINavigationController {
        let fetcher = ChatRoomFetcherStub(result: .success(ChatRoomFetcherStub.stubs))
        let viewModel = ChatRoomsViewModel(fetcher: fetcher, auth: auth, realTimeListener: realTimeListener)
        viewModel.onChatSelected = actions.onChatSelected
        let chatController = ChatRoomsViewController(viewmodel: viewModel)
        let navController = UINavigationController(rootViewController: chatController)
        configureNavigationalOptions(navigationController: navController)
        //navController.navigationBar.isHidden = true
        return navController
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.topViewController?.title = "Chats"
    }
}
