//
//  isotest.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class isotest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
    func testExample() throws {
        let isoString = "2022-03-13T12:00:33.135Z"
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(isoString)
        
        let decoder: JSONDecoder = .withFractionalSecondISO8601
        
        let date = try decoder.decode(Date.self, from: encoded)
        
        let anotherDecoder = JSONDecoder()
        anotherDecoder.dateDecodingStrategy = .iso8601
        
        //let other = try anotherDecoder.decode(Date.self, from: try encoder.encode("2022-03-13T12:00:33Z"))
       
    }
     */

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
