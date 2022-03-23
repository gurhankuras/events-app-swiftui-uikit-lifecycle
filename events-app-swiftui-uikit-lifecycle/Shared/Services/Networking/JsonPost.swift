//
//  JsonPost.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine

protocol JsonPost {
    func post<T: Encodable>(url: URL, with body: T, headers: [String: String], responseHandler: ((HTTPURLResponse) -> Void)?) -> AnyPublisher<Data, Error>
}

extension JsonPost {
    func post<T: Encodable>(url: URL, with body: T) -> AnyPublisher<Data, Error> {
        post(url: url, with: body, headers: [:], responseHandler: nil)
    }
}

extension JsonPost {
    
}

enum NetworkError: LocalizedError {
    case response([ErrorMessage])
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .response(let array):
            return array.first?.message
        case .other(let err):
            return "Bir hata oldu"
        }
    }
}

extension URLSession: JsonPost {
    func post<T: Encodable>(url: URL, with body: T, headers: [String: String] = [:], responseHandler: ((HTTPURLResponse) -> Void)? = nil) -> AnyPublisher<Data, Error> {
        
        guard let data = try? JSONEncoder().encode(body) else {
            return Fail(error: NetworkError.other(URLError.init(.badURL))).eraseToAnyPublisher()
        }
    
        let request = makeJSONRequest(url, with: data, method: .post, withExtraHeaders: headers)
        
        
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
                
                responseHandler?(response)
                
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
