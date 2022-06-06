//
//  TokenSaverDecorator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

struct TokenSaverDecorator: HttpClient {
    let decoratee: HttpClient
    let store: TokenStore
    
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponseBundle, Error>) -> Void) {
        decoratee.request(request) { result in
            if case let .success(bundle) = result,
               let token = bundle.response.value(forHTTPHeaderField: "Authorization") {
                store.save(token)
                print("Saved token: \(token)")
            }
            completion(result)
        }
    }
}
