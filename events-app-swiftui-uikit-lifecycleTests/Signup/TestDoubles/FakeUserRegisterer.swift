
//
//  FakeUserRegisterer.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

/// simulates user signed up before or not. if user signed up before then returns error
class FakeUserRegisterer: UserAuthenticator {
  
    
    let realRegisterer: UserAuthenticator
    let registeredUserEmails: [String]
    
    init(realRegisterer: UserAuthenticator, registeredUserEmails: [String] = []) {
        self.realRegisterer = realRegisterer
        self.registeredUserEmails = registeredUserEmails
    }
    
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        if registeredUserEmails.contains(email.value) {
            return Fail(error: SignupError.userAlreadyExists([ErrorMessage(message: "User already exists")]))
                .eraseToAnyPublisher()
        }
        return realRegisterer.handle(email: email, password: password)
    }

}
