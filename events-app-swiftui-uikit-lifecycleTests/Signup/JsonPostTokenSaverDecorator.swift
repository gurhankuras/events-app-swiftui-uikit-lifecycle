//
//  JsonPostTokenSaverDecorator.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import XCTest
import Combine
@testable import events_app_swiftui_uikit_lifecycle


func makeResponseBundle<T: Encodable>(encodable: T?, statusCode: Int, headers: [String: String] = [:]) throws -> ResponseBundle {
    var data: Data?
    if let encodable = encodable {
        data = try JSONEncoder().encode(encodable)
    }
    let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: headers)
    return ResponseBundle(data: data, response: response)
}


class TokenSaverTests: XCTestCase {
   
    
    
    func test_whenAccessTokenReceived_savesTokenToStore() throws {
        let store = InMemoryTokenStore(tokens: [:])
        let bundle = try makeResponseBundle(encodable: aCodable, statusCode: 200, headers: ["Authorization": "123456"])
        let client = HttpClientStub(result: .success(bundle))
        let sut = TokenSaverDecorator(decoratee: client, store: store)
        
        XCTAssertNil(store.get())
        let request = URLRequest(url: aURL)
        let cancellable = sut.request(request, completion: {_ in })
        
        XCTAssertNotNil(store.get())
    }
    
    func test_whenAccessTokenNotReceived_doesNothing() throws {
        let store = InMemoryTokenStore(tokens: [:])
        let expectedToken = "123456"
        let bundle = try makeResponseBundle(encodable: aCodable, statusCode: 200)
        let client = HttpClientStub(result: .success(bundle))
        let sut = TokenSaverDecorator(decoratee: client, store: store)
        
        XCTAssertNil(store.get())

        let request = URLRequest(url: aURL)

        sut.request(request, completion: {_ in })
        
        XCTAssertNil(store.get())
    }
}
