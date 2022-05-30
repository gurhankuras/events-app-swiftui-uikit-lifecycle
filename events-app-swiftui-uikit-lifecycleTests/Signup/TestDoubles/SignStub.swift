//
//  UserRegistererStub.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

class SignInStub: EmailSignIn {
    let result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
    func login(email: Email, password: Password, completion: @escaping (Result<User, Error>) -> ()) {
        switch result {
        case .success(let user):
            completion(.success(user))
            return
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
}

class SignUpStub: EmailSignUp {
    let result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
    
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ()) {
        switch result {
        case .success(let user):
            completion(.success(user))
            return
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
}
