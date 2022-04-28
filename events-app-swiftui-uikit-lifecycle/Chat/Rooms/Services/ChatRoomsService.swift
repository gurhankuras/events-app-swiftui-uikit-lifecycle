//
//  ChatRoomsService.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation
import Combine

protocol ChatRoomFetcher {
    func fetch(for user: User) -> AnyPublisher<[Room], Error>
}

class ChatRoomFetcherStub: ChatRoomFetcher {
    let result: Result<[Room], Error>
    
    init(result: Result<[Room], Error>) {
        self.result = result
    }
    
    func fetch(for user: User) -> AnyPublisher<[Room], Error> {
        switch result {
            
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .success(let chats):
            return Just(chats)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: sample stubs
extension ChatRoomFetcherStub {
    static var stubs: [Room] {
        return [
            Room(id: "123", imageUrl: "pikachu", name: "Julia", message: "Nice!", timestamp: .init(), lastSender: .init(id: "2", name: "Eren", image: nil)),
            Room(id: "234", imageUrl: "pikachu", name: "Joe", message: "What's up", timestamp: .init(), lastSender: .init(id: "2", name: "Eren", image: nil))
        ]
    }
}

class RemoteChatRoomFetcher: ChatRoomFetcher {
    let network: JsonGet

    init(network: JsonGet) {
        self.network = network
    }
    
    func fetch(for user: User) -> AnyPublisher<[Room], Error> {
        guard let url = URL(string: "http://gkevents.com/api/chat/rooms") else {
            return Fail(error: URLError.init(URLError.badURL))
                .eraseToAnyPublisher()
        }
        
        let mapper = RemoteChatRoomMapper(for: user)
        return network.get(url: url)
            .decode(type: [RemoteChatRoom].self, decoder: JSONDecoder.withFractionalSecondISO8601)
            .map({ chatRooms in
                return chatRooms.map { room in
                    return mapper.map(room: room)
                }
            })
            .eraseToAnyPublisher()
    }
}




