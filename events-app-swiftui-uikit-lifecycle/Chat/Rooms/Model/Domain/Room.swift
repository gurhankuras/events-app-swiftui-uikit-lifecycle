//
//  RecentMessage.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation


struct Room: Identifiable {

    var id: String
    
    let imageUrl: String
    let name: String
    let message: String
    let timestamp: Date?
    let lastSender: ChatUser?

    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(for: timestamp) ?? ""
    }
}

struct RoomViewModel: Identifiable {

    var id: String
    let imageUrl: String
    let name: String
    let message: String
    let timestamp: Date?
    let lastSender: ChatUser?
    var select: ((ChatRepresentation) -> Void)?
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(for: timestamp) ?? ""
    }
    
    
    var asChatRepresentation: ChatRepresentation {
        ChatRepresentation(roomId: id, userId: nil, image: imageUrl, name: name)
    }
    
}

struct ChatRepresentation {
    var roomId: String?
    let userId: String?
    let image: String
    let name: String
}


struct ChatUser: Identifiable {
    let id: String
    let name: String
    let image: String?
    
    var select: ((ChatRepresentation) -> Void)?
    
    init(id: String, name: String, image: String? = nil, select: ((ChatRepresentation) -> Void)? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.select = select
    }
    
    var asDeneme: ChatRepresentation {
        ChatRepresentation(roomId: nil, userId: id, image: image ?? "no-image", name: name)
    }
}
