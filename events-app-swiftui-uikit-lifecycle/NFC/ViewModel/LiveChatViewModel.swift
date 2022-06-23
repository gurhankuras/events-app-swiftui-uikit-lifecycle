//
//  LiveChatViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/8/22.
//

import Foundation
import RxSwift
import RxCocoa

class LiveChatViewModel {
    // TODO: inject
    let room = LiveChatRoom()

    let messages = BehaviorRelay<[LiveChatMessage]>(value: [])
    var text = BehaviorRelay(value: "")
    
    var canSendMessage: Observable<Bool> {
        text.asObservable()
            .map({ !$0.isEmpty })
    }
    
    func send() {
        room.send(message: text.value)
        text.accept("")
    }
    
    init() {
        room.onReceiveMessage = { [weak self] msg in
            self?.addMessage(.init(image: "user", timestamp: "10:32 AM", username: msg.user, text: msg.text))
        }
        
        fireDemoMessages()
    }
    
    func fireDemoMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            let demo = LiveChatMessage(image: "hisoka", timestamp: "8:05 PM", username: "Gurhan", text: "Nice one")
            self?.addMessage(demo)
        }
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { [weak self] in
            let demo = LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "Not bad!")
            self?.addMessage(demo)
        }
         */
    }
    
    func addMessage(_ message: LiveChatMessage) {
        let finalMessages = messages.value.appended(LiveChatMessage(image: "hisoka", timestamp: "8:18 PM", username: "Gurhan", text: "Nice one"))
        messages.accept(finalMessages)
    }
}



/*
 
 messages.value = [
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "Not sure which team gonna win"),
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "Not sure which team gonna win"),
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf"),
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "Not sure which team gonna win"),
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "what is this question lol sadasdfdgdfg fdgdfgdfgfdg dsfdsfdsfdsfdsfdsfdsf"),
     LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"),
     LiveChatMessage(image: "user", timestamp: "9:36 AM", username: "Coci", text: "Not sure which team gonna win")
 ]
 */
