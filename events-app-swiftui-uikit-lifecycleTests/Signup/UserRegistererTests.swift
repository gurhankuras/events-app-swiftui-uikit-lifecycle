//
//  UserRegistererTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class UserRegistererTests: XCTestCase {
    func makeValidCredentials() -> (Email, Password) {
        let email: Email = "test@test.com"
        let password: BasicPassword = "123456789"
        return (email,password)
    }
    
    
    func test_registererReturnsUser_whenUserNotRegisteredBefore() throws {
        let (email, password) = makeValidCredentials()
        let responseContent = RemoteUser(id: "123dsd3", email: email.value)
        let signUp = FakeSignUp(realService: SignUpStub(result: .success(.init(id: responseContent.id, email: responseContent.email, image: nil))))
        
        var user: User?
        signUp.signUp(with: .init(name: "Joe", emailAddress: email.value, password: password.value), completion: { result in
            user = try! result.get()
        })
       
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.email, email.value)
    }
    
    func test_registererReturnsError_whenUserAlreadyRegistered() throws {
        let (email, password) = makeValidCredentials()
        let expectedError = ErrorMessage(message: "User already exists")
        
        let signUp = FakeSignUp(realService: SignUpStub(result: .failure(SignupError.userAlreadyExists([expectedError]))), registeredUserEmails: [email.value])
        
        var error: Error?
        signUp.signUp(with: .init(name: "Joe", emailAddress: email.value, password: password.value)) { result in
            if case let .failure(e) = result {
                error = e
            }
        }
        // TODO:
        XCTAssertNotNil(error)
    }
    

}
