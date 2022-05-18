//
//  ClampTest.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 5/18/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class ClampTest: XCTestCase {

    func test_ReturnsMinValue_WhenValueLessThanMin() {
        let value = -100
        let result = clamp(value, min: 0, max: 150)
        XCTAssertEqual(result, 0)
    }
    
    func test_ReturnsMaxValue_WhenValueGreaterThanMax() {
        let value = 200
        let result = clamp(value, min: 0, max: 150)
        XCTAssertEqual(result, 150)
    }
    
    func test_ReturnsSelf_WhenValueBetweenMinAndMax() {
        let result = clamp(75, min: 0, max: 150)
        XCTAssertEqual(result, 75)
    }

}
