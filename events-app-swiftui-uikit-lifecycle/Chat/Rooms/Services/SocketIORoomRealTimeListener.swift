//
//  SocketIORoomRealTimeListener.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/28/22.
//

import Foundation
import SocketIO


class SocketIORoomRealTimeListener: RoomRealTimeListener {
    //var onReceive: ((RemoteChatRoom) -> Void)?

    struct DecodingError: Error {}

    let logger = AppLogger(type: SocketIOChatCommunicator.self)
    let manager: SocketManager
    let socket: SocketIOClient!
    let tokenStore: TokenStore
    
    deinit {
        logger.e(#function)
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    init(manager: SocketManager, tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        self.manager = manager
        self.socket = SocketIOClient(manager: manager, nsp: "/room")
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
        //receive()
    
        
    }
    
    private func setToken(conf: inout SocketIOClientConfiguration) {
        if let token = tokenStore.get() {
            conf.insert(.extraHeaders(["access-token": token]))
        }
    }
    
    func receive(completion: @escaping (RemoteChatRoom) -> Void) {
        print(ServerChatEvent.roomUpdated.rawValue)
        
        socket.on(ServerChatEvent.roomUpdated.rawValue) { [weak self] data, ack in
                print(data)
        }
        /*
        socket.on(ServerChatEvent.roomUpdated.rawValue) { [weak self] rawData, ack in
            self?.logger.d(rawData)
            DispatchQueue.global(qos: .default).async {
                guard let jsonString = rawData[0] as? String,
                      let data = jsonString.data(using: .utf8),
                      let room = try? JSONDecoder.withFractionalSecondISO8601.decode(RemoteChatRoom.self, from: data)
                else {
                    print("An error occured while decoding RemoteChatRoom")
                    return
                }
                //self?.onReceive?(room)
                completion(room)
            }
        }
         */
        
    }
}
