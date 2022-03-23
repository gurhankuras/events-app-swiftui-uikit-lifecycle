//
//  XCTest+Common.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/21/22.
//

import Foundation
import Combine
import XCTest

@testable import events_app_swiftui_uikit_lifecycle

extension AnyPublisher {
    func emptySink() -> AnyCancellable {
        return sink(receiveCompletion: {_ in}, receiveValue: {_ in})
    }
}

extension XCTestCase {
    var aCodable: RemoteUser {
        return RemoteUser(id: "123", email: "test@test.com")
    }
    
    var aToken: String {
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NDc4NTM5NTYuNzQzMTgxLCJpYXQiOjE2NDc4NTM4NTYuNzQzMzQyOX0.g-jxUewWLO1P5Hj6fXJMl-aJkwInwi1n2UcAJan2gKM"
    }
    
    
    var aURL: URL {
        return URL(string: "www.test.com")!
    }
}
