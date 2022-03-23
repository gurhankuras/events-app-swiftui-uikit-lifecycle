//
//  JsonPostTokenSaverDecorator.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine

class JsonPostTokenSaverDecorator: JsonPost {
    let decoratee: JsonPost
    let store: TokenStore
    
    init(decoratee: JsonPost, store: TokenStore) {
        self.decoratee = decoratee
        self.store = store
    }
    
    func post<T>(url: URL, with body: T, headers: [String : String], responseHandler: ((HTTPURLResponse) -> Void)?) -> AnyPublisher<Data, Error> where T : Encodable {
        decoratee.post(url: url, with: body, headers: headers) { [weak self] response in
            if let accessToken = response.value(forHTTPHeaderField: "access-token") {
                print("ACCESS TOKEN VARMIS")
                
                self?.store.save(accessToken)
            }
        }
    }
}
