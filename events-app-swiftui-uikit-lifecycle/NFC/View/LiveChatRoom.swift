//
//  LiveChatRoom.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/8/22.
//

import Foundation
import os
import SocketIO

func generateRandomBytes() -> String? {

    var keyData = Data(count: 32)
    let result = keyData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
    }
    if result == errSecSuccess {
        return keyData.base64EncodedString()
    } else {
        print("Problem generating random bytes")
        return nil
    }
}

class LiveChatRoom {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LiveChatRoom.self))
    
    let socket: SocketIOClient
    let manager: SocketManager
    let username = generateRandomBytes()!
    var onReceiveMessage: ((RemoteLiveChatMessage) -> ())?
    
    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:6000")!, config: [.log(false)])
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else {
                Self.logger.info("self not exists")
                return
            }
            Self.logger.log("socket connectedassda")
            self.socket.emit("login", ["name": self.username, "room": 1])
        }
        socket.on("1") { _, __ in
            Self.logger.log("Odaya girdi")
        }
        
        socket.on("message") { [weak self] msg, a in
            guard let message = msg.first as? [String: String] else { return }
            guard let e = try? RemoteLiveChatMessage.fromDict(message) else { return }
            self?.onReceiveMessage?(e)
        }
        //socket.connect()
        socket.connect()
    }
    
    func send(message: String) {
        //let data = try! JSONEncoder().encode(message)
        
        socket.emit("sendMessage", ["message": message])
    }
}

struct Errrr: Error {}

struct RemoteLiveChatMessage: Decodable {
    let timestamp: Date
    let text: String
    let user: String
    
    // TODO: remove and use decodable
    static func fromDict(_ dict: [String: Any]) throws -> RemoteLiveChatMessage {
        guard
                //timestamp = dict["timestamp"] as? String,
            let text = dict["text"] as? String,
            let user = dict["user"] as? String else {
            throw Errrr()
        }
        return RemoteLiveChatMessage(timestamp: Date(), text: text, user: user)
    }
}
