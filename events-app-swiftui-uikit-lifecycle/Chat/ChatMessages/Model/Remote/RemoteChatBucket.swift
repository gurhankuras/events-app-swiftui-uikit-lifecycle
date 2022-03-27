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

/*
 {
         text: 'hello',
         sender: {
           _id: new ObjectId("507f191e810c19729de860ec"),
           name: 'Gurhan',
           __v: 0
         },
         nonce: '710f5f1061',
         sentAt: 2022-03-27T17:24:05.943Z,
         _id: new ObjectId("62409db5c1407281662a79fa")
       }
 */
 
