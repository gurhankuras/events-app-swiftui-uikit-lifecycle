//
//  Registerer.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import Foundation
import Combine

struct ErrorMessage: Codable, Equatable {
    let message: String
}

enum SignupError: LocalizedError {
    case userAlreadyExists([ErrorMessage])
    case other(Error?)
    
    var errorDescription: String? {
        switch self {
        case .userAlreadyExists(let array):
            return array.first?.message
        case .other(let optional):
            return optional?.localizedDescription
        }
    }
    
    
}


class UserSignUpAuthenticator: UserAuthenticator {
    let network: JsonPost

    init(network: JsonPost) {
        self.network = network
    }
    
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "http://gkevents.com/api/users/signup") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return network.post(url: url, with: Credentials(email: email.value, password: password.value))
            .decode(type: RemoteUser.self, decoder: JSONDecoder())
            .map({ $0.asUser })
            .eraseToAnyPublisher()
    }
}


class FakeRegisterer: UserAuthenticator {
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        Just(User(id: "dummy-id", email: "dummy@dummy.com"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
