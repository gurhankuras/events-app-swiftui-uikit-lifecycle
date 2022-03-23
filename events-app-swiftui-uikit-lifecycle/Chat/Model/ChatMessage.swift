//
//  ChatMessage.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation
import UIKit

// TODO: CreatedChatMessage (without id) - RemoteChatMessage(?) - ChatMessage (with id)

struct ChatMessage: Identifiable {

    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
  
    init(id: String, sender: ChatUser, message: String, timestamp: Date, image: UIImage? = nil) {
        self.id = id
        self.sender = sender
        self.message = message
        self.timestamp = timestamp
        self.image = image
    }
    
    let id: String
    let sender: ChatUser
    let message: String
    let timestamp: Date
    let image: UIImage?
    
    
    var time: String {
        Self.dateFormatter.string(from: timestamp)
    }
    
    func belongs(to user: User) -> Bool {
        return sender.id == user.id
    }
     
}

/*
struct PresentableChatMessage {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    init(senderName: String, message: String, timestamp: Date, image: UIImage? = nil) {
        self.senderName = senderName
        self.message = message
        self.timestamp = timestamp
        self.image = image
    }
    
    let senderName: String
    let message: String
    let timestamp: Date
    let image: UIImage?
    
    var time: String {
        Self.dateFormatter.string(from: timestamp)
    }
}
 */


extension ChatMessage {
    static var stubWithImage = ChatMessage(id: "234", sender: ChatUser(id: "123", name: "Gurhan", image: nil), message: "Hey nasilsin ya", timestamp: Date(), image: .init(named: "concert"))
}
