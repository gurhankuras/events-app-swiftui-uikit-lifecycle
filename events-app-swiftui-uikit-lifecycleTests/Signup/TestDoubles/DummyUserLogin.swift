//
//  DummyUserLogin.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/18/22.
//

import Foundation
import Combine

@testable import events_app_swiftui_uikit_lifecycle
import XCTest

class DummyUserlogin: UserAuthenticator {
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        XCTFail("shouldn't interact with this method")
        return Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

class DummyUserSignIn: EmailSignIn {
    func login(email: Email, password: Password, completion: @escaping (Result<User, Error>) -> ()) {
        XCTFail("shouldn't interact with this method")
    }
}

class DummyUserSignUp: EmailSignUp {
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ()) {
        XCTFail("shouldn't interact with this method")
    }
    

}
