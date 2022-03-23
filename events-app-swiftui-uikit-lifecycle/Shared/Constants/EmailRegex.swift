//
//  EmailRegex.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import Foundation

let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let emailRegexPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)

/*
 
 
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
 */
