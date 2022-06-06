//
//  UserLogin.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle


func makeResponse(statusCode: Int) -> HTTPURLResponse {
    return HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}


class UserSignInTests: XCTestCase {
    func test_signIn_returnsUser() throws {
        let email: Email = "test@test.com"
        let password: BasicPassword = "12345"
        let remoteUser = RemoteUser(id: "123", email: email.value)
        let data = try! JSONEncoder().encode(remoteUser)
        let response = makeResponse(statusCode: 200)
        
        let stubbedClient = HttpClientStub(result: .success(.init(data: data, response: response)))
        let userSignIn = UserSignIn(client: stubbedClient)
        var user: User?
        userSignIn.login(email: email, password: password, completion: { result in
            if case let .success(usr) = result {
                user = usr
            }
        })
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.email, remoteUser.email)
    }
    
    func test_signIn_returnsError() throws {
        let email: Email = "test@test.com"
        let password: BasicPassword = "12345"
        let stubbedClient = HttpClientStub(result: .failure(URLError.init(.badServerResponse)))
        let userSignIn = UserSignIn(client: stubbedClient)
        
        var error: Error?
        userSignIn.login(email: email, password: password, completion: { result in
            if case let .failure(e) = result {
                error = e
            }
        })
        XCTAssertNotNil(error)
        
    }
     
}

