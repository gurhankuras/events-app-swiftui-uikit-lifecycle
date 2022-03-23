//
//  MessageSocket.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation
// import SocketIO

/*
class MessageSocket {
    let logger = AppLogger(type: MessageSocket.self)
    let manager: SocketManager
    let socket: SocketIOClient!
    var onReceive: ((_ message: String) -> Void)?
    
    
    private let clientListenerName = "hello"
    private let serverListenerName = "toServer"
    
    deinit {
        logger.e(#function)
        socket.disconnect()
        socket.removeAllHandlers()
    }
    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://gkevents.com/api/chat")!, config: [ .log(false) ])
        self.socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            self?.logger.i("connection established!")
        }
        self.listen()
        self.connect()
    }
    
    private func listen() {
        socket.on(clientListenerName) { [weak self] data, ack in
            self?.logger.d(data)
            guard let message = data[0] as? String else {
                print("bir hata oldu")
                return
            }
            self?.onReceive?(message)
        }
    }
    
    func send(message: String) {
        self.socket.emit(serverListenerName, with: [message])
    }
    
    private func connect() {
        manager.connect()
    }
}
 */
