//
//  FakeTokenStore.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/18/22.
//

import Foundation
@testable import events_app_swiftui_uikit_lifecycle

class InMemoryTokenStore: TokenStore {
    private(set) var tokens: [String:String]
    
    
    init(tokens: [String: String] = [:]) {
        self.tokens = tokens
    }
    
    func save(_ token: String) {
        tokens.updateValue(token, forKey: "access-token")
    }
    
    func get() -> String? {
        return tokens["access-token"]
    }
    
    func delete() {
        tokens.removeValue(forKey: "access-token")
    }
}
