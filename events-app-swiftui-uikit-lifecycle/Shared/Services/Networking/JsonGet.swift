//
//  JsonGet.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//


import Foundation
import Combine

protocol JsonGet {
    func get(url: URL, headers: [String: String]) -> AnyPublisher<Data, Error>
}

extension JsonGet {
    func get(url: URL) -> AnyPublisher<Data, Error> {
        get(url: url, headers: [:])
    }
}

extension JsonGet {
    func restrictedAccess() -> JsonGet {
        return JsonGetAuthDecorator(decoratee: self, store: SecureTokenStore(keychain: .standard))
    }
}


extension URLSession: JsonGet {
    public func get(url: URL, headers: [String: String] = [:]) -> AnyPublisher<Data, Error> {
        let request = makeJSONRequest(url, with: nil, method: .get, withExtraHeaders: headers)
        
        return dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {
                    guard let errorMessage = try? JSONDecoder().decode([ErrorMessage].self, from: output.data) else {
                        throw NetworkError.other(URLError.init(.badServerResponse))
                    }
                    throw NetworkError.response(errorMessage)
                }
                            
                return output.data
            }
            //.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
