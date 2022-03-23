//
//  ChatMessagesApiClient.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import Combine

enum JsonReadError: String, Error {
    case fileNotFound = "Specified file couldn't be located!"
    case other = "Other"
}
struct CreatedChatMessage: Encodable {
    let sender: String
    let text: String
    let image: String?
}

func convertDataToJsonObject(data: Data) throws -> [String: Any] {
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
        throw JsonReadError.other
    }
    print(json)
    return json
}

class ChatMessagesApiClient {
    struct SecondError: Error {}
    struct BadPresignedURL: Error {}
    
    let network: JsonPost
    
    init(network: JsonPost) {
        self.network = network
    }
    
    func send(message: CreatedChatMessage, roomId: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "http://gkevents.com/api/chat/rooms/\(roomId)/messages") else {
            return Fail(error: URLError.init(.badURL)).eraseToAnyPublisher()
        }
        
        return network.post(url: url, with: message, headers: [:], responseHandler: nil)
            .map({ data in
                true
            })
            .eraseToAnyPublisher()
    }
    
}

