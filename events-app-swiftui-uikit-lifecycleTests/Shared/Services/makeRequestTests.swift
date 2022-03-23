//
//  makeRequestTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/22/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class makeRequestTests: XCTestCase {

    func test_post_witoutData() throws {
        let testHeaders = ["a": "x", "b": "y"]
        let request = makeJSONRequest(aURL, with: nil, method: .get, withExtraHeaders: testHeaders)
        
        XCTAssertEqual(request.url, aURL)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
        XCTAssertEqual(request.value(forHTTPHeaderField: "a"), testHeaders["a"])
        XCTAssertEqual(request.value(forHTTPHeaderField: "b"), testHeaders["b"])
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?.count, 3)
    }
    
    func test_post_withData() throws {
        let testHeaders = ["a": "x", "b": "y"]
        let data = try JSONEncoder().encode(aCodable)
        let request = makeJSONRequest(aURL, with: data, method: .post, withExtraHeaders: testHeaders)
        
        XCTAssertEqual(request.url, aURL)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.value(forHTTPHeaderField: "a"), testHeaders["a"])
        XCTAssertEqual(request.value(forHTTPHeaderField: "b"), testHeaders["b"])
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?.count, 3)
    }
}
