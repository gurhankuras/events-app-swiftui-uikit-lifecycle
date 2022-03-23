//
//  UserLogin.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class RemoteUserLoginTest: XCTestCase {
    func test_login_returnsUser() throws {
        let email: Email = "test@test.com"
        let password: BasicPassword = "12345"
        let remoteUser = RemoteUser(id: "123", email: email.value)
        let networkStub = JsonPostNetworkStub(result: .success(remoteUser))
        let userLogin = UserSignInAuthenticator(network: networkStub)
        
        var user: User?
        let exp = expectation(description: "user")
        let cancellable = userLogin.handle(email: email, password: password)
            .sink { _ in
                
            } receiveValue: { returnedUser in
                user = returnedUser
                exp.fulfill()
            }

        waitForExpectations(timeout: 0.2)
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.email, remoteUser.email)
        cancellable.cancel()
    }
    
    func test_login_returnsError() throws {
        let email: Email = "test@test.com"
        let password: BasicPassword = "12345"
        let remoteUser = RemoteUser(id: "123", email: email.value)
        let networkStub = JsonPostNetworkStub<RemoteUser>(result: .failure(URLError.init(.badServerResponse)))
        let userLogin = UserSignInAuthenticator(network: networkStub)
        
        var error: Error?
        let exp = expectation(description: "error")
        let cancellable = userLogin.handle(email: email, password: password)
            .sink { completion in
                if case let .failure(e) = completion {
                    error = e
                    exp.fulfill()
                }
            } receiveValue: { _ in
            }

        waitForExpectations(timeout: 0.2)
        XCTAssertNotNil(error)
        cancellable.cancel()
    }
}

