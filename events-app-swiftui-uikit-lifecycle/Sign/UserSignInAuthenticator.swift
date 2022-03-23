//
//  UserLogin.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation
import Combine


protocol UserAuthenticator {
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error>
}

class UserSignInAuthenticator: UserAuthenticator {
    private let network: JsonPost
    
    init(network: JsonPost) {
        self.network = network
    }
    
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "http://gkevents.com/api/users/signin") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        let credentials = Credentials(email: email.value, password: password.value)
        
        return network.post(url: url, with: credentials)
            .decode(type: RemoteUser.self, decoder: JSONDecoder())
            .map({ $0.asUser })
            .eraseToAnyPublisher()
    }
}
