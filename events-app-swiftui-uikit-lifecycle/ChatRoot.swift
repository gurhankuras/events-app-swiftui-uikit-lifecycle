//
//  ChatRoot.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import Foundation
import SwiftUI

class CompositionRoot: ObservableObject {
    let chat: ChatRoot = ChatRoot()
}


class ChatRoot: ObservableObject {
    @Published var showChatMessages: Bool = false
    @Published var chat: RecentChat?

    func tappedChat(for chat: RecentChat) {
        self.chat = chat
        showChatMessages = true
    }
    
    @ViewBuilder func chatLogs() -> some View {
        if showChatMessages {
            let viewModel = ChatMessagesViewModel(chat: chat!)
            ChatMessagesView(viewModel: viewModel)
        }
        else {
            EmptyView()
        }
    }
}
