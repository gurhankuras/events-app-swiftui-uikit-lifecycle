//
//  RecentMessage.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation


struct RecentChat: Identifiable {

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

struct RecentChatViewModel: Identifiable {

    var id: String
    
    let imageUrl: String
    let name: String
    let message: String
    let timestamp: Date?
    let lastSender: ChatUser?
    var select: ((RecentChatViewModel) -> Void)?
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(for: timestamp) ?? ""
    }
}


struct ChatUser: Identifiable {
    let id: String
    let name: String
    let image: String?
    
    var select: ((RecentChat?) -> Void)?
    
    init(id: String, name: String, image: String? = nil, select: ((RecentChat?) -> Void)? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.select = select
    }
}
