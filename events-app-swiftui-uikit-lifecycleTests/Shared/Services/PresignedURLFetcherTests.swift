//
//  PresignedURLFetcherTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class PresignedURLFetcherTests: XCTestCase {
    
    func test_fetch_returns() {
        let info = PresignedUrlInfo(url: "www.test.com", key: "123/abc.jpeg")
        let network = JsonGetNetworkStub(result: .success(info))
        let sut = PresignedURLFetcher(network: network)
        
        let cancellable = sut.fetch().sink { comp in
            switch comp {
            case .failure(_):
                XCTFail("should return url")
                break
            case .finished:
                break
            }
        } receiveValue: { url in
            XCTAssertEqual(url.path, info.url)
        }
        
        cancellable.cancel()
        
    }
     
}
