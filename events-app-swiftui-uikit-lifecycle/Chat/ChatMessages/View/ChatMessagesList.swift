//
//  ChatMessagesList.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import SwiftUI
import Combine

struct ChatMessagesList: View {
    let messages: [ChatMessage]
    let scrollPublisher: PassthroughSubject<String, Never>
    let onMessageAppear: (ChatMessage) -> Void
    let belongsToUser: (ChatMessage) -> Bool
    
    init(_ messages: [ChatMessage],
         scrollPublisher: PassthroughSubject<String, Never>,
         onMessageAppear: @escaping (ChatMessage) -> Void,
         belongsToUser: @escaping (ChatMessage) -> Bool
    ) {
        
        self.messages = messages
        self.scrollPublisher = scrollPublisher
        self.onMessageAppear = onMessageAppear
        self.belongsToUser = belongsToUser
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    Spacer().frame(height: 15)

                    ForEach(messages) { message in
                        ChatBubble(message, isMe: belongsToUser(message))
                            .id(message.id)
                            .reverseScroll()
                            .transition(.move(edge: .top))
                            .onAppear {
                                onMessageAppear(message)
                            }
                    }
                    .onReceive(scrollPublisher) { id in
                        scrollToBottom(proxy: proxy, id: id)
                    }
                }
                .padding(.horizontal)
            }
        }
        .reverseScroll()
    }
    
    
    
    private func scrollToBottom(proxy: ScrollViewProxy, id: String?) {
        guard let id = id else { return }
        print(id)
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    proxy.scrollTo(id)
                }
            }
    }
}


struct ChatMessagesList_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesList(
            ChatMessage.stubs(4),
            scrollPublisher: .init(),
            onMessageAppear: {_ in},
            belongsToUser: {_ in true}
        )
    }
}

