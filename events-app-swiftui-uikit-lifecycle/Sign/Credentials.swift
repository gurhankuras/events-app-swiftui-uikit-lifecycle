//
//  Credentials.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import Foundation



protocol Validatable {
    var isValid: Bool { get }
}

struct Credentials: Validatable, Codable {
    
    let email: String
    let password: String
    
    private func isValidEmail() -> Bool {
        emailRegexPred.evaluate(with: email)
    }
    
    private func isValidPassword() -> Bool {
        password.count >= 5
    }
    var isValid: Bool {
        isValidEmail() && isValidPassword()
    }
    
}
