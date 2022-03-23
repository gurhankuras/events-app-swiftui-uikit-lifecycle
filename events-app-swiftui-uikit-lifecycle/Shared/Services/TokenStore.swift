//
//  TokenStore.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation

protocol TokenStore {
    func save(_ token: String)
    func `get`() -> String?
    func delete()
}

class SecureTokenStore: TokenStore {
    func delete() {
        keychain.removeObject(forKey: Self.accessTokenKey, withAccessibility: .whenUnlocked)
    }
    
    let keychain: KeychainWrapper
    private static let accessTokenKey: String = "access-token"
    
    init(keychain: KeychainWrapper) {
        self.keychain = keychain
    }
    
    func save(_ token: String) {
        let saved = keychain.set(token, forKey: Self.accessTokenKey, withAccessibility: .whenUnlocked)
        print(saved)
    }
    
    func `get`() -> String? {
        return keychain.string(forKey: Self.accessTokenKey, withAccessibility: .whenUnlocked)
    }
}
