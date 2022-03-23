//
//  JsonPostTokenSaverDecorator.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import XCTest
import Combine
@testable import events_app_swiftui_uikit_lifecycle





class JsonPostTokenSaverDecoratorTests: XCTestCase {
   
    
    func test_whenAccessTokenReceived_savesTokenToStore() throws {
        let store = FakeTokenStore(tokens: [:])
        let network = JsonPostNetworkStub(result: .success(aCodable))
        let sut = JsonPostTokenSaverDecorator(decoratee: network, store: store)
        
        XCTAssertNil(store.get())

        let cancellable = sut.post(url: aURL, with: aCodable).emptySink()
        defer { cancellable.cancel() }
        
        XCTAssertNotNil(store.get())
    }
    
    func test_whenAccessTokenNotReceived_doesNothing() throws {
        let store = FakeTokenStore(tokens: [:])
        let network = JsonPostNetworkStub(result: .success(aCodable), sendsToken: false)
        let sut = JsonPostTokenSaverDecorator(decoratee: network, store: store)
        
        XCTAssertNil(store.get())

        let cancellable = sut.post(url: aURL, with: aCodable).emptySink()
        defer { cancellable.cancel() }
        
        XCTAssertNil(store.get())
    }
}
