//
//  File.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/4/22.
//

import Foundation
import LocalAuthentication

protocol EventSearchEngine {
    func search(for q: String, options: SearchOptions, completion: @escaping (Result<[SearchedEvent], Error>) -> ())
}

struct SearchOptions {
    let pageNumber: Int
    let pageSize: Int
}

enum EventSearchError: LocalizedError {
    case notAuthorized
    case general(reason: String)
}

struct EventSearchServiceStub: EventSearchEngine {
    let result: Result<[SearchedEvent], Error>

    init(_ result: Result<[SearchedEvent], Error>) {
        self.result = result
    }    
    
    func search(for q: String, options: SearchOptions, completion: @escaping (Result<[SearchedEvent], Error>) -> ()) {
        completion(result)
    }
}
class EventSearchService: EventSearchEngine {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }

    func search(for q: String, options: SearchOptions, completion: @escaping (Result<[SearchedEvent], Error>) -> ()) {
        let httpRequest = makeRequest(q: q, options: options)
        client.request(httpRequest) { result in
            switch result {
            case .success(let bundle):
                let statusCode = bundle.response.statusCode
                if statusCode == 401 || statusCode == 500 {
                    completion(.failure(statusCode == 401 ? EventSearchError.notAuthorized : EventSearchError.general(reason: "Server Error")))
                    return
                }
                guard let data = bundle.data else {
                    completion(.failure(EventSearchError.general(reason: "Expected a payload from server but didn't receive")))
                    return
                }
                if statusCode == 200 {
                    guard let events = try? JSONDecoder.withFractionalSecondISO8601.decode([SearchedEvent].self, from: data) else {
                        completion(.failure(EventSearchError.general(reason: "Couldn't decode server response")))
                        return
                    }
                    completion(.success(events))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    private func makeRequest(q: String, options: SearchOptions) -> URLRequest {
        var components = URLComponents(string: "http://\(hostName):\(port)/dev/search/events")!
        components.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "pageNumber", value: String(options.pageNumber)),
            URLQueryItem(name: "pageSize", value: String(options.pageSize))
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
    
}
