//
//  LiveChatViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/8/22.
//

import Foundation
import Combine

class LiveChatViewModel {
    let messages = CurrentValueSubject<[LiveChatMessage], Never>([])
    let room = LiveChatRoom()
    var didLoadMessages: (() -> ())?
    
    init() {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.addMessage(LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "This is awesome"))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { [weak self] in
            self?.addMessage(LiveChatMessage(image: "user", timestamp: "9:35 AM", username: "Natalie Portie", text: "Not bad!"))
        }
    }
    
    private func addMessage(_ message: LiveChatMessage) {
        var a = self.messages.value
        a.append(message)
        self.messages.send(a)
    }
    
    /*
    let messages2: [LiveChatMessage] =  [
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
}
