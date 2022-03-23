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
