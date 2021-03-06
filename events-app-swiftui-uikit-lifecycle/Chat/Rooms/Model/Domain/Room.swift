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


