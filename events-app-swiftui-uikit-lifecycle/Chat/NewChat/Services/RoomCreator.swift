//
//  RoomCreator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/28/22.
//

import Foundation
import Combine

class RoomCreator {
    let network: JsonPost
    
    init(network: JsonPost) {
        self.network = network
    }
    
    func create(userId: String) ->  AnyPublisher<RemoteChatRoom, Error> {
        guard let url = URL(string: "http://gkevents.com/api/chat/conversation") else {
            return Fail(error: URLError(URLError.badURL)).eraseToAnyPublisher()
        }
        let userDict = ["userId": userId]
        let decoder = JSONDecoder.withFractionalSecondISO8601
        return network.post(url: url, with: userDict, headers: [:], responseHandler: nil)
            .decode(type: RemoteChatRoom.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
