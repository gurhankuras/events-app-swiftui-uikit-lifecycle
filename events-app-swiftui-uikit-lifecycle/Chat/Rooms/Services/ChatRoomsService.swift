//
//  ChatRoomsService.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation
import Combine

/*
protocol ChatRoomFetcher {
    func fetch(for user: User) -> AnyPublisher<[Room], Error>
}
 */

protocol ChatRoomFetcher {
    func fetch(for user: User, completion: @escaping (Result<[Room], Error>) -> ())
}

/*
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
*/
// MARK: sample stubs
/*
 // TODO: fix this
extension ChatRoomFetcherStub {
    static var stubs: [Room] {
        return [
            Room(id: "123", imageUrl: "pikachu", name: "Julia", message: "Nice!", timestamp: .init(), lastSender: .init(id: "2", name: "Eren", image: nil)),
            Room(id: "234", imageUrl: "pikachu", name: "Joe", message: "What's up", timestamp: .init(), lastSender: .init(id: "2", name: "Eren", image: nil))
        ]
    }
}
 */

/*
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
 */

class RemoteChatFetcher: ChatRoomFetcher {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func fetch(for user: User, completion: @escaping (Result<[Room], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:3000/api/chat/rooms") else {
            return completion(.failure(URLError.init(.badURL)))
        }
        let request = URLRequest(url: url)
        
        let mapper = RemoteChatRoomMapper(for: user)
        client.request(request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bundle):
                guard let data = bundle.data else {
                    completion(.failure(URLError.init(.badServerResponse)))
                    return
                }
                let response = bundle.response
                
                do {
                    print(response.statusCode)
                    if response.statusCode == 200 {
                        let remoteRooms = try JSONDecoder.withFractionalSecondISO8601.decode([RemoteChatRoom].self, from: data)
                        let rooms = remoteRooms.map(mapper.map(room:))
                        completion(.success(rooms))
                    }
                    else {
                        // TODO: handle other status codes
                    }
                } catch {
                    completion(.failure(error))
                }
               
            }
        }
    }
}




