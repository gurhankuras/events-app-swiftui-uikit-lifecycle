//
//  RemoteChatBucket.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation

// MARK: - Welcome
struct RemoteChatBucket: Codable {
    let id, roomID: String
    let count: Int
    let creationDate: String
    let messages: [RemoteChatBucketMessage]

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case count, creationDate, messages, id
    }
}

// MARK: - Message
struct RemoteChatBucketMessage: Codable {
    let id: String
    let text: String
    let sender: RemoteChatRoomUser
    let sentAt: Date
   
}
