//
//  ChatCommunicator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/26/22.
//

import Foundation
import SocketIO

// TODO: move these to seperate files
enum ClientChatEvent: String {
    case send
    var rawValue: String {
        switch self {
        case .send:
            return "client:send"
        }
    }
}

enum ServerChatEvent: String {
    class MyType {
        
    }
    case send
    var rawValue: String {
        switch self {
        case .send:
            return "server:send"
        }
    }
}


struct DemoMessage: Codable {
    let text: String
    let roomId: String
}

enum Message {
    case text(String)
}

protocol ChatCommunicator {
    func send(message: Message, to room: String, completion: @escaping () -> Void)
    func receive(on event: ServerChatEvent, callback: @escaping (Result<RemoteChatBucketMessage, Error>) -> Void)
}


class SocketIOChatCommunicator: ChatCommunicator {
    struct DecodingError: Error {}

    let logger = AppLogger(type: SocketIOChatCommunicator.self)
    let manager: SocketManager
    let socket: SocketIOClient!
    let tokenStore: TokenStore
    let roomId: String

    private let serverEvent = ServerChatEvent.send
    private let clientEvent = ClientChatEvent.send
    
    deinit {
        logger.e(#function)
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    init(roomId: String, manager: SocketManager, tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        self.roomId = roomId
        self.manager = manager
        self.socket = manager.defaultSocket
        setToken(conf: &manager.config)

        socket.on(clientEvent: .connect) {[weak self] data, ack in
            self?.logger.i("connection established!")
            self?.logger.i(data)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("disconnected")
        }
        
        socket.on(clientEvent: .reconnect) { data, ack in
            print("reconnecting")
        }
    
        manager.connect()
    }
    
    private func setToken(conf: inout SocketIOClientConfiguration) {
        if let token = tokenStore.get() {
            conf.insert(.extraHeaders(["access-token": token, "room": roomId]))
        }
    }
    
    func send(message: Message, to room: String, completion: @escaping () -> Void) {
        switch message {
        case .text(let chatMessage):
            let msg = DemoMessage(text: chatMessage, roomId: room)
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(msg),
                let encoded = String(data: data, encoding: .utf8) else { return }
            
            self.socket.emit(clientEvent.rawValue, with: [encoded], completion: completion)
        }
        
    }
    
    func receive(on event: ServerChatEvent, callback: @escaping (Result<RemoteChatBucketMessage, Error>) -> Void) {
        socket.on(event.rawValue) { [weak self] message, ack in
            self?.logger.d(message)
            DispatchQueue.global(qos: .default).async {
                guard let jsonString = message[0] as? String,
                      let data = jsonString.data(using: .utf8),
                      let msg = try? JSONDecoder.withFractionalSecondISO8601.decode(RemoteChatBucketMessage.self, from: data)
                      
                else {
                    callback(.failure(DecodingError()))
                    return
                }
                callback(.success(msg))
            }
        }
    }
}
