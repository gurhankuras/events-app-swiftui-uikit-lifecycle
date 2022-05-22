//
//  HttpClient+Decorators.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

extension HttpClient {
    func tokenSaver(store: TokenStore) -> HttpClient {
        TokenSaverDecorator(decoratee: self, store: store)
    }
    
    func tokenSender(store: TokenStore) -> HttpClient {
        JWTBearerTokenSenderDecorator(decoratee: self, store: store)
    }
}
