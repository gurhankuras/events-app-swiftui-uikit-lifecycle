//
//  ChatBubble.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    let isMe: Bool

    init(_ message: ChatMessage, isMe: Bool) {
        self.message = message
        self.isMe = isMe
    }
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(message.sender.name)
                        .font(.system(size: 16))
                        .bold()
                    Spacer().frame(width: 50)
                    //Spacer()
                    
                }
                if let image = message.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                }
                
                Text(message.message)
                    .font(.system(size: 14))
            }
            .overlay(
                Text(message.time)
                    .font(.system(size: 12)),
                alignment: .topTrailing
            )
            .foregroundColor(.white)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(isMe ? .pink : Color(.systemGray)))
            .frame(maxWidth: 300, alignment: isMe ? .trailing : .leading)
            .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
        }
    }
}

/*
struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatBubble(ChatMessage.stubs(1, sender: "Gurhan").first!)
            ChatBubble(ChatMessage.stubs(1, sender: "Other").first!)
            ChatBubble(ChatMessage.stubWithImage)

        }
        .padding()
            .previewLayout(.sizeThatFits)
    }
}
*/
