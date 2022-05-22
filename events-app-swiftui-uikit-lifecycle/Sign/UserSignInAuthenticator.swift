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

/*
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
*/

class UserSignIn {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func login(email: Email, password: Password, completion: @escaping (Result<User, Error>) -> ()) {
        
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
        guard let url = URL(string: "http://localhost:5000/account/signin") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: Dictionary<String, String> = ["email": email.value, "password": password.value]
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
    private func respond(to statusCode: Int, with data: Data, completion: @escaping (Result<User, Error>) -> ()) {
        let decoder = JSONDecoder()
        do {
            print(statusCode)
            if statusCode == 200 {
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
