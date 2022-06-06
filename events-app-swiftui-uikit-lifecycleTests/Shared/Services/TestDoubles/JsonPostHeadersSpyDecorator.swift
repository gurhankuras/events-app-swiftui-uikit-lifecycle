//
//  JsonPostHeaderSpyDecorator.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/21/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle

class JsonPostHeadersSpyDecorator: JsonPost {
    var headers: [String: String]?
    let decoratee: JsonPost
    
    init(decoratee: JsonPost) {
        self.decoratee = decoratee
    }
    
    func post<T>(url: URL, with body: T, headers: [String : String], responseHandler: ((HTTPURLResponse) -> Void)?) -> AnyPublisher<Data, Error> where T : Encodable {
        self.headers = headers
        
        return decoratee.post(url: url, with: body, headers: headers, responseHandler: responseHandler)
    }
}

class HeaderSnifferDecorator: HttpClient {
    let decoratee: HttpClient
    var headers: [String: String]?
    
    init(decoratee: HttpClient) {
        self.decoratee = decoratee
    }
    
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponseBundle, Error>) -> Void) {
        self.headers = request.allHTTPHeaderFields
        decoratee.request(request, completion: completion)
    }
}

extension HttpClient  {
    func headerSniffer() -> HeaderSnifferDecorator {
        return HeaderSnifferDecorator(decoratee: self)
    }
}
