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

    
    func setupFixture(strategy: TokenStrategy) -> (HttpClient, HeaderSnifferDecorator, TokenStore) {
        let tokenStore = InMemoryTokenStore()
        let sniffer = HttpClientStub(result: .success(.init(data: nil, response: .init())))
                        .headerSniffer()
        let sut = sniffer.tokenSender(store: tokenStore, strategy: strategy)
        return (sut, sniffer, tokenStore)
    }
    
    
    func test_post_doesNotSetAuthHeaders_IfTokenNotFound() {
        // Arrange
        let strategy: TokenStrategy = .bearer
        let (sut, spy, _) = setupFixture(strategy: strategy)
        let request = URLRequest(url: aURL)
        
        // Act
        sut.request(request, completion: { _ in })
        
        // Assert
        XCTAssertNil(spy.headers?[strategy.headerName])
    }
    
    
    func test_post_setsAuthHeaders_IfTokenExists() throws {
        // Arrange
        let strategy: TokenStrategy = .bearer
        let (sut, sniffer, store) = setupFixture(strategy: strategy)
        store.save(aToken)
        let request = URLRequest(url: aURL)

        // Act
        sut.request(request, completion: { _ in })
        
        // Assert
        let headers = try XCTUnwrap(sniffer.headers)
        XCTAssertEqual(headers.isEmpty, false)
        XCTAssertEqual(headers[strategy.headerName], strategy.formatted(aToken))
    }
    
    

}
