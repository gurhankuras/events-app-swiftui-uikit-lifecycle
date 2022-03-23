//
//  RemoteChatRoom.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation

struct RemoteChatRoom: Decodable, Identifiable {
    let id: String
    let participants: [RemoteChatRoomUser]
    let lastMessage: RemoteChatRoomLastMessage?
}


struct RemoteChatRoomUser: Codable {
    let id, name: String
    let image: String?
}

struct RemoteChatRoomLastMessage: Decodable {
    let sentAt: Date
    let sender: RemoteChatRoomUser
    let text: String
}
