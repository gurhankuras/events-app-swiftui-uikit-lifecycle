//
//  ChatUsersList.swift
//  play
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI

struct ChatUsersList: View {
    let users: [ChatUser]
    
    var body: some View {
            ScrollView {
                VStack {
                    ForEach(users) { user in
                        Button {
                            user.select?(user)
                        } label: {
                            ChatUserCell(user: user)
                        }
                        .foregroundColor(.black)

                    }
                }
            }
            .background(Color.appPurple.brightness(0.9))
    }
}

struct ChatUsersList_Previews: PreviewProvider {
    static var previews: some View {
        ChatUsersList(users: [
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil),
            ChatUser(id: "1", name: "Gurhan", image: nil)
        ])
    }
}
