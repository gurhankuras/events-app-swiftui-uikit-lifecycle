//
//  JsonGetAuthDecorator.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine

class JsonGetAuthDecorator: JsonGet {
    let decoratee: JsonGet
    let tokenStore: TokenStore
    
    init(decoratee: JsonGet, store: TokenStore) {
        self.decoratee = decoratee
        self.tokenStore = store
    }
    
    func get(url: URL, headers: [String : String] = [:]) -> AnyPublisher<Data, Error> {
        let h = withToken(headers: headers)
        return decoratee.get(url: url, headers: h)
    }
    
    // TODO: change name current name implies that token always exists
    private func withToken(headers: [String: String]) -> [String: String] {
        guard let accessToken = tokenStore.get() else {
            print("TOKEN BULUNAMADI - AUTHORIZEDNETWORKSERVICE")
            return headers
        }
        
        let headersWithToken = headers.merging(["access-token": accessToken]) { _, new in new }
        return headersWithToken
    }
}
