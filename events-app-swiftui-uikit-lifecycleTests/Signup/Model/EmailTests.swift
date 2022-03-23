//
//  EmailTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/18/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class EmailTests: XCTestCase {
    
    func test_isValid_returnsFalse_WhenEmailJustConsistsOfUsername() {
        let sut: Email = "test"
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_returnsFalse_WhenEmailDoesNotContainMailServerAndDomain() {
        let sut: Email = "test@"
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_returnsFalse_WhenEmailDoesNotContainDomain() {
        let sut: Email = "test@test."
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_returnsFalse_WhenEmailDomainIsOneCharacterLong() {
        let sut: Email = "test@test.t"
        XCTAssertFalse(sut.isValid)
    }
    
    func test_isValid_returnsTrue_WhenEmailIsValid() {
        let sut: Email = "test@test.com"
        XCTAssertTrue(sut.isValid)
    }

}
