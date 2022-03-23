//
//  BasicPassword.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation

protocol Password {
    var value: String { get }
}

struct BasicPassword: Password, FormField, Validatable, ExpressibleByStringLiteral {
    var value: String

    init(stringLiteral value: String) {
        self.value = value
    }    
    
    var isValid: Bool {
        value.count >= 5
    }
}

