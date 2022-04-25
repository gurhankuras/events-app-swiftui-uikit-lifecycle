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
    let scroller: ChatScroller
    let onMessageAppear: (ChatMessage) -> Void
    let userOwnsMessage: (ChatMessage) -> Bool
    
    init(_ messages: [ChatMessage],
         scroller: ChatScroller,
         onMessageAppear: @escaping (ChatMessage) -> Void,
         userOwnsMessage: @escaping (ChatMessage) -> Bool
    ) {
        
        self.messages = messages
        self.scroller = scroller
        self.onMessageAppear = onMessageAppear
        self.userOwnsMessage = userOwnsMessage
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    Spacer().frame(height: 15)

                    ForEach(messages) { message in
                        ChatBubble(message, isMe: userOwnsMessage(message))
                            .id(message.id)
                            .reverseScroll()
                            .transition(.move(edge: .top))
                            .onAppear {
                                onMessageAppear(message)
                            }
                    }
                    .onReceive(scroller.publisher) { id in
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
            scroller: .init(),
            onMessageAppear: {_ in},
            userOwnsMessage: {_ in true}
        )
    }
}

