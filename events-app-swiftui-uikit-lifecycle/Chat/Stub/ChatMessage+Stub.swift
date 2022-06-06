//
//  ChatMessage+StubExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation


#if DEBUG
extension ChatMessage {
    static func stubs(_ count: Int = 10, sender: String? = nil) -> [ChatMessage] {
        let texts = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris volutpat, dolor vitae scelerisque laoreet, sapien quam commodo mi, a cursus quam risus ac velit. Aenean iaculis neque sem, id tristique ex pharetra in. Suspendisse tortor ipsum, commodo a leo eget, rhoncus aliquam tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam volutpat, ipsum accumsan molestie vulputate, dui mi tempor erat, ut vulputate erat eros eu ex. Nunc eu dapibus lectus. Nunc molestie, magna quis sodales volutpat, sem libero scelerisque neque, vel tristique lacus risus in eros. Pellentesque urna orci, cursus a dictum eget, malesuada nec dolor. Donec vulputate rutrum lectus nec fringilla. Proin hendrerit convallis viverra. Nulla id viverra libero. Nunc aliquet eget mi quis commodo. Mauris nec sem convallis sem hendrerit pretium vitae nec nulla. Suspendisse fermentum placerat placerat.",
        
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris volutpat, dolor vitae scelerisque laoreet, sapien quam commodo mi, a cursus quam risus ac velit. Aenean iaculis neque sem, id tristique ex pharetra in. Suspendisse tortor ipsum, commodo a leo eget, rhoncus aliquam tortor.",
        "vitae scelerisque laoreet, sapien quam commodo mi, a cursus quam risus ac velit. Aenean iaculis neque sem"
        ]
        return (0...count).map { _ in
            let text = texts.randomElement()!
            let date = Date().addingTimeInterval(Double((0...3600).randomElement()!))
            
            return ChatMessage(id: UUID().uuidString, sender: ChatUser(id: "1", name: "Gurhan", image: nil), message: text, timestamp: date)
        }
    }
}
#endif

