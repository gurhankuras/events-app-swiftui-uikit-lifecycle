//
//  FormField.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation


protocol FormField {
    var value: String { get set }
    mutating func update(with newValue: String)

    mutating func reset()
}

extension FormField {
    mutating func reset() {
        update(with: "")
    }
    
    mutating func update(with newValue: String) {
        value = newValue
    }
}
