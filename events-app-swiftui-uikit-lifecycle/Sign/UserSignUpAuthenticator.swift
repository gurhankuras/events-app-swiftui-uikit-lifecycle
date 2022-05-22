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
    let emailAddress: String
    let password: String
    let name: String
}


class UserSignUp {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func signUp(email: Email, password: Password, completion: @escaping (Result<User, Error>) -> ()) {
        
        guard let request = makeRequest(email: email, password: password) else {
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
    
    private func makeRequest(email: Email, password: Password) -> URLRequest? {
        guard let url = URL(string: "http://localhost:5000/account") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = SignUpRequest(emailAddress: email.value, password: password.value, name: "Deneme")
        request.httpBody = try? JSONEncoder().encode(body)
        return request
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
