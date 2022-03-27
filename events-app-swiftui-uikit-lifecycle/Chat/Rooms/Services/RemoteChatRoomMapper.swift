//
//  RemoteChatRoomMapper.swift
//  play
//
//  Created by Gürhan Kuraş on 3/22/22.
//

import Foundation

struct RemoteChatRoomMapperDefaultValues {
    let text: String
    let image: String
    let name: String
    let date: Date?
}

fileprivate let defaultValuess: RemoteChatRoomMapperDefaultValues = .init(text: "", image: "no-image", name: "", date: nil)

struct RemoteChatRoomMapper {
    static let defaultValues = defaultValuess
    
    private let currentUser: User
    private(set) var defaults: RemoteChatRoomMapperDefaultValues

    init(for user: User, defaults: RemoteChatRoomMapperDefaultValues = Self.defaultValues) {
        self.currentUser = user
        self.defaults = defaults
    }
    
    func map(room: RemoteChatRoom) -> Room {
        let roomName = name(for: room)
        let message = text(for: room)
        let image = image(for: room)
        let date = sentAt(for: room)
        
        var lastSender: ChatUser?
        if room.lastMessage?.sender != nil {
            lastSender = ChatUser(id: room.lastMessage!.sender.id, name: room.lastMessage!.sender.name, image: room.lastMessage!.sender.image)
        }
        
        return Room(id: room.id,
                          imageUrl: image,
                          name: roomName,
                          message: message,
                          timestamp: date,
                          lastSender: lastSender
        )
    }
    
    private func isMe(user: RemoteChatRoomUser) -> Bool {
        return user.id == currentUser.id
    }
    
    private func name(for room: RemoteChatRoom) -> String {
        room.participants.first{ !isMe(user: $0) }?.name ?? defaults.name
    }
    
    private func text(for room: RemoteChatRoom) -> String {
        room.lastMessage?.text ?? defaults.name
    }
    
    private func image(for room: RemoteChatRoom) -> String {
        room.participants.first{ !isMe(user: $0) }?.image ?? defaults.image
    }
    
    private func sentAt(for room: RemoteChatRoom) -> Date? {
        room.lastMessage?.sentAt ?? defaults.date
    }
}
