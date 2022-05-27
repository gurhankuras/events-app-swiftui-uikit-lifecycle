//
//  ChatViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit

protocol ChatViewControllerFactory {
    var signController: ((() -> ()) -> UIViewController)? { get set }
    func controller(onChatSelected: @escaping (RoomViewModel) -> (), onStartedNewChat: @escaping () -> (),
                    onSign: @escaping () -> ()) -> UINavigationController
    func chatUsersController(onClosedUsers: @escaping () -> (), onSelectedNewChat: @escaping (ChatUser) -> ()) -> UIViewController
    func chatMessagesController(room: Room, onBack: @escaping () -> ()) -> UIViewController
}



