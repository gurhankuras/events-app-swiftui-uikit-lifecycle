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
        let registerer = FakeUserRegisterer(realRegisterer: UserSignUpAuthenticator(network: JsonPostNetworkStub(result: .success(responseContent))))

        let spy = UserRegistererSpy(authenticator: registerer)
        spy.handle(email: email, password: password)
       
        XCTAssertEqual(spy.user?.email, email.value)
    }
    
    func test_registererReturnsError_whenUserAlreadyRegistered() throws {
        let (email, password) = makeValidCredentials()
        let expectedErrors = [ErrorMessage(message: "User already exists")]
        let registerer = FakeUserRegisterer(realRegisterer: UserSignUpAuthenticator(network: JsonPostNetworkStub<RemoteUser>(result: .failure(SignupError.userAlreadyExists(expectedErrors)))),
                                            registeredUserEmails: [email.value])

        let spy = UserRegistererSpy(authenticator: registerer)
        spy.handle(email: email, password: password)
        guard let error = spy.error as? SignupError else {
            XCTFail("fail and die")
            return
        }
        
        switch error {
        case .userAlreadyExists(let errors):
            XCTAssertEqual(errors, expectedErrors)
        default:
            XCTFail("Type mismatch")
        }
    }
    

}
