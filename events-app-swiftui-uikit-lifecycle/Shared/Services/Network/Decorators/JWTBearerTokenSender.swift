//
//  JWTBearerTokenSender.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

struct JWTBearerTokenSenderDecorator: HttpClient {
    let decoratee: HttpClient
    let store: TokenStore


    func request(_ request: URLRequest, completion: @escaping (Result<ResponseBundle, Error>) -> Void) {
        var req = request
        if let token = store.get() {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        decoratee.request(req, completion: completion)
    }
}
