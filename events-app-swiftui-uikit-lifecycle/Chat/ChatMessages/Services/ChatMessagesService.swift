//
//  ChatMessagesService.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import Combine

extension Array {
    func alternating(with others: [Element]) -> [Element] {
        var list = [Element]()
        zip(self, others).forEach { (first, second) in
            list.append(first)
            list.append(second)
        }
        return list
    }
}

protocol ChatMessageFetcher {
    func fetch(for roomId: String, at page: Int) -> AnyPublisher<[ChatMessage], Error>
}

class RemoteChatMessageFetcher: ChatMessageFetcher {
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    
    func fetch(for roomId: String, at page: Int) -> AnyPublisher<[ChatMessage], Error> {
        guard let url = URL(string: "http://localhost:3000/api/chat/rooms/\(roomId)/messages?page=\(page)") else {
            return Fail(error: URLError.init(URLError.badURL))
                .eraseToAnyPublisher()
        }
        
        let decoder: JSONDecoder = .withFractionalSecondISO8601
        return session.get(url: url)
            .decode(type: [RemoteChatBucket].self, decoder: decoder)
            .map({ chatBuckets in
                return chatBuckets.flatMap { bucket in
                    return bucket.messages.map({ ChatMessage(id: $0.id, sender: ChatUser(id: $0.sender.id, name: $0.sender.name, image: $0.sender.image), message: $0.text, timestamp: $0.sentAt )})
                }
                .reversed()
            })
            .eraseToAnyPublisher()
    }
    
    
}
