//
//  LiveChatRoom.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/8/22.
//

import Foundation
import os
import SocketIO

class LiveChatRoom {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LiveChatRoom.self))
    
    let socket: SocketIOClient
    let manager: SocketManager
    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:6000")!, config: [.log(false)])
        self.socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            Self.logger.log("socket connectedassda")
        }
        socket.on("1") { _, __ in
            Self.logger.log("Odaya girdi")
        }
        socket.connect()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.socket.emit("login", ["name": "gurhan", "room": 1])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.send(message: "DENEME")
        }
    }
    
    func send(message: String) {
        //let data = try! JSONEncoder().encode(message)
        
        socket.emit("sendMessage", message)
    }
}
