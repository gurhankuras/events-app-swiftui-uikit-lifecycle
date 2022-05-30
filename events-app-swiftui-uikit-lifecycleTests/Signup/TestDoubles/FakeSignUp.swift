
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
class FakeSignUp: EmailSignUp {
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ()) {
        if registeredUserEmails.contains(request.emailAddress) {
            completion(.failure(SignupError.userAlreadyExists([ErrorMessage(message: "User already exists")])))
            return
        }
        realService.signUp(with: request, completion: completion)
    }
    
    let realService: EmailSignUp
    let registeredUserEmails: [String]

    init(realService: EmailSignUp, registeredUserEmails: [String] = []) {
        self.realService = realService
        self.registeredUserEmails = registeredUserEmails
    }
}
