//
//  ChatToolbar.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI

struct ChatToolbar: View {
    let chat: RecentChatViewModel
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                   onBack()
                    print("dismiss")
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.title)
                }
                
                HStack {
                    Button {
                        // TODO: Show fullscreen profile image
                    } label: {
                        
                        Image(chat.imageUrl)
                            .resizable()
                            .scaledToFill()
                            .size(40)
                            .clipped()
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                        
                    .padding(.trailing, 5)
                    Text(chat.name)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                Spacer()
            }
        }
    }
}
        
/*
struct ChatToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ChatToolbar(chat: <#T##RecentChatViewModel#>)
    }
}
*/
