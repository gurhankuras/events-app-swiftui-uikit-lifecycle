//
//  Email.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation

struct Email: FormField, Validatable, ExpressibleByStringLiteral {
    var value: String

    init(stringLiteral value: String) {
        self.value = value
    }    

    var isValid: Bool {
        emailRegexPred.evaluate(with: value)
    }
}
