//
//  JsonGetNetworkStub.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/21/22.
//

import Foundation

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

class JsonGetNetworkStub<M: Encodable>: JsonGet {
    let result: Result<M, Error>
    
    init(result: Result<M, Error>) {
        self.result = result
    }
    
    func get(url: URL, headers: [String : String]) -> AnyPublisher<Data, Error> {
        switch result {
            case .success(let body):
            do {
                let data = try JSONEncoder().encode(body)
                
                return Just(data)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            catch let error {
                return Fail<Data, Error>(error: error)
                    .eraseToAnyPublisher()
            }

        case .failure(let error):
            return Fail<Data, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}
