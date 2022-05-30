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

struct SignUpRequest: Encodable {
    let name: String
    let emailAddress: String
    let password: String
}



protocol EmailSignUp {
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ())
}

class UserSignUp: EmailSignUp {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ()) {
        
        guard let request = makeRequest(request: request) else {
            completion(.failure(URLError.init(.badURL)))
            return
        }
        
        client.request(request) { [weak self] result in
            switch result {
            case .success(let bundle):
                guard let response = bundle.response,
                      let data = bundle.data else {
                          completion(.failure(URLError.init(.badServerResponse)))
                          return
                      }
                self?.respond(to: response.statusCode, with: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(request: SignUpRequest) -> URLRequest? {
        guard let url = URL(string: "http://localhost:5000/account") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = try? JSONEncoder().encode(request)
        return req
    }
    
    private func respond(to statusCode: Int, with data: Data, completion: @escaping (Result<User, Error>) -> ()) {
        let decoder = JSONDecoder()
        do {
            print(statusCode)
            if statusCode == 201 {
                let remoteUser = try decoder.decode(RemoteUser.self, from: data)
                completion(.success(remoteUser.asUser))
            }
            else if statusCode == 400 {
                let message = try decoder.decode(ErrorMessage.self, from: data)
                completion(.failure(NetworkError.response([message])))
            }
            else {
                completion(.failure(URLError.init(.cannotConnectToHost)))
            }
        } catch {
            completion(.failure(error))
        }
        
    }
    
    
}


class FakeRegisterer: UserAuthenticator {
    func handle(email: Email, password: Password) -> AnyPublisher<User, Error> {
        Just(User(id: "dummy-id", email: "dummy@dummy.com"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
