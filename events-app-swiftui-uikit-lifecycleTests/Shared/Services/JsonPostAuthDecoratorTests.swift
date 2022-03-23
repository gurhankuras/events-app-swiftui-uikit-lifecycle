//
//  JsonPostAuthDecoratorTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/21/22.
//

import XCTest
import Combine
@testable import events_app_swiftui_uikit_lifecycle


class JsonPostAuthDecoratorTests: XCTestCase {

    
    func setupFixture() -> (JsonPostAuthDecorator, JsonPostHeadersSpyDecorator, TokenStore) {
        let tokenStore = FakeTokenStore()
        let spy = JsonPostHeadersSpyDecorator(decoratee: JsonPostNetworkStub(result: .success(aCodable)))
        let sut = JsonPostAuthDecorator(decoratee: spy, store: tokenStore)
        return (sut, spy, tokenStore)
    }
    
    func test_post_doesNotSetAuthHeaders_IfTokenNotFound() {
        let (sut, spy, _) = setupFixture()
        
        let cancellable = sut.post(url: aURL, with: aCodable, headers: [:], responseHandler: nil).emptySink()
        
        defer { cancellable.cancel() }
        
        XCTAssertNotNil(spy.headers)
        XCTAssertTrue(spy.headers!.isEmpty)
        
    }
    
    func test_post_setsAuthHeaders_IfTokenExists() throws {
        let (sut, spy, store) = setupFixture()
        store.save(aToken)

        let cancellable = sut.post(url: aURL, with: aCodable, headers: [:], responseHandler: nil).emptySink()
        
        defer { cancellable.cancel() }
        
        let headers = try XCTUnwrap(spy.headers)
        XCTAssertNotNil(headers)
        XCTAssertEqual(headers.isEmpty, false)
        XCTAssertEqual(headers["access-token"], aToken)
        
    }

}
