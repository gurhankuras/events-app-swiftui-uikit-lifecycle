//
//  JsonPostAuthDecorator.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine

class JsonPostAuthDecorator: JsonPost {
    let decoratee: JsonPost
    let tokenStore: TokenStore
    
    init(decoratee: JsonPost, store: TokenStore) {
        self.decoratee = decoratee
        self.tokenStore = store
    }
    
    func post<T>(url: URL, with body: T, headers: [String : String] = [:], responseHandler: ((HTTPURLResponse) -> Void)?) -> AnyPublisher<Data, Error> where T : Encodable
    {
        let newHeaders = addingToken(to: headers)
        return decoratee.post(url: url, with: body, headers: newHeaders, responseHandler: responseHandler)
    }

    
    private func addingToken(to headers: [String: String]) -> [String: String] {
        guard let accessToken = tokenStore.get() else {
            print("TOKEN BULUNAMADI - AUTHORIZEDNETWORKSERVICE")
            return headers
        }
        let headersWithToken = headers.merging(["access-token": accessToken]) { _, new in new }
        return headersWithToken
    }
}
