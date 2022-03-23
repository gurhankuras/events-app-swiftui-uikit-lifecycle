//
//  JsonPostNetworkStub.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

class JsonPostNetworkStub<M: Encodable>: JsonPost {
    let result: Result<M, Error>
    let sendsToken: Bool
    
    init(result: Result<M, Error>, sendsToken: Bool = true) {
        self.result = result
        self.sendsToken = sendsToken
    }
    
    func post<M>(url: URL, with body: M, headers: [String : String], responseHandler: ((HTTPURLResponse) -> Void)?) -> AnyPublisher<Data, Error> {
        switch result {
            case .success(let body):
            do {
                let data = try JSONEncoder().encode(body)
                
                if sendsToken {
                    let response = makeResponse()
                    responseHandler?(response)
                }
                
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
    
    private func makeResponse() -> HTTPURLResponse {
        let headers = ["access-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyMzM4ZDAxNTVkNjM2ZGNlNjExYjExMiIsImVtYWlsIjoidGV2ZmlrQGdtYWlsLmNvbSIsImlhdCI6MTY0NzU0NTYwMSwiZXhwIjoxNjQ3NTQ5MjAxfQ.iCwmthDgzVfKQRd_1GnWGOC598HKcOe7DjCo2TqaWbM"]
        return HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: 200, httpVersion: "2", headerFields: headers)!
    }
}
