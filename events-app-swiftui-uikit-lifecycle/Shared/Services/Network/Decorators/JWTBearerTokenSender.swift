//
//  JWTBearerTokenSender.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

protocol TokenStrategy {
    var headerName: String { get set }
    func formatted(_ token: String) -> String
}

extension TokenStrategy where Self == BearerTokenStrategy {
    static var bearer: Self {
        .init(forHTTPHeader: "Authorization")
    }
}

struct BearerTokenStrategy: TokenStrategy {
    var headerName: String
    
    init(forHTTPHeader name: String) {
        self.headerName = name
    }
    
    func formatted(_ token: String) -> String {
        return "Bearer \(token)"
    }
}

struct TokenSenderDecorator: HttpClient {
    
    init(decoratee: HttpClient, store: TokenStore, strategy: TokenStrategy = .bearer) {
        self.decoratee = decoratee
        self.store = store
        self.strategy = strategy
    }
    
    private let decoratee: HttpClient
    private let store: TokenStore
    private let strategy: TokenStrategy

    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponseBundle, Error>) -> Void) {
        var req = request
        if let tokenText = store.get() {
            let token = strategy.formatted(tokenText)
            req.addValue(token, forHTTPHeaderField: strategy.headerName)
        }
        decoratee.request(req, completion: completion)
    }
}
