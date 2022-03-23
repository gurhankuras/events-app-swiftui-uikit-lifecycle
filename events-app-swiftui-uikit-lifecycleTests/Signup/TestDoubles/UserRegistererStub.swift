//
//  UserRegistererStub.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

class UserRegistererStub: UserAuthenticator {
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        switch result {
        case .success(let user):
            return Just(user)
                .setFailureType(to: Error.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    let result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
}

extension UserSignUpAuthenticator {
    static func stub(result: Result<User, Error>) -> UserRegistererStub {
        UserRegistererStub(result: result)
    }
}
