//
//  Singup.swift
//  playTests
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import XCTest

@testable import events_app_swiftui_uikit_lifecycle
import Combine


class Singup: XCTestCase {
    let logger = AppLogger(type: Singup.self)
    
   
    func test_signup_formIsInvalidAtStart() throws {
        let (_, spy) = makeInputValidationSUT()
        
        let formValidity = try XCTUnwrap(spy.values.last)
        XCTAssertEqual(formValidity, false)
    }
    
    func test_signup_formIsInvalidWithInvalidPassword() throws {
        let (sut, spy) = makeInputValidationSUT()
        
        sut.email = makeValidEmail()
        sut.password = "123"

        let formValidity = try XCTUnwrap(spy.values.last)
        
        XCTAssertEqual(formValidity, false)
    }
    
    func test_signup_formIsInvalidWithInvalidEmail() throws {
        let (sut, spy) = makeInputValidationSUT()
        
        sut.email = "test@testcom"
        sut.password = makeValidPassword()

        let formValidity = try XCTUnwrap(spy.values.last)
        
        XCTAssertEqual(formValidity, false)
    }
    
    func test_signup_formIsValidWithValidCredentials() throws {
        let (sut, spy) = makeInputValidationSUT()
        
        sut.name = "Joe"
        sut.email = makeValidEmail()
        sut.password = makeValidPassword()
        
        let formValidity = try XCTUnwrap(spy.values.last)
        print(spy.values)
        
        XCTAssertEqual(formValidity, true)
    }
    
     
    
    func test_signup_ErrorShouldBeShownWhenFailedSignUp() {
        let email: Email = makeValidEmail()
        let password: BasicPassword = makeValidPassword()
        let user = User(id: "123", email: email.value)
        let expectedErrorText = "deneme"
        let signUpFailure = Result<User, Error>.failure(SignupError.userAlreadyExists([ErrorMessage(message: expectedErrorText)]))
        let signIn = UserSignIn(client: HttpAPIClient.shared)
        let auth = AuthService(signUp: SignUpStub(result: signUpFailure), signIn: signIn, tokenStore: InMemoryTokenStore())
        
        /*
        AuthService(registerer: UserRegistererStub(result: .failure(SignupError.userAlreadyExists([ErrorMessage(message: expectedErrorText)]))), userLogin: UserSignInAuthenticator(network: URLSession.shared), tokenStore: FakeTokenStore())
         */
        let sut = SignupViewModel(auth: auth, didSignIn: {})
        
        //let spy = TestSpy(.eraseToAnyPublisher())
        
        
        let exp = expectation(description: "sign")
        
        var actualErrorText: String?
        let cancellable = sut.$error.dropFirst().sink { error in
            actualErrorText = error
            exp.fulfill()
        }
        sut.password = password
        sut.email = email
        sut.signUp()
        waitForExpectations(timeout: 2)
        logger.e(sut.error)
        
        XCTAssertNotNil(actualErrorText)
        //XCTAssertEqual(actualErrorText, expectedErrorText)
        cancellable.cancel()
    }
    
    func test_signup_callsCallbackAfterSignedUp() {
        let email: Email = makeValidEmail()
        let password: BasicPassword = makeValidPassword()
        let user = User(id: "123", email: email.value)
        let signUp = SignUpStub(result: .success(user))
        let signIn = UserSignIn(client: HttpAPIClient.shared)
        //let auth = AuthService(registerer: UserRegistererStub(result: .success(user)), userLogin: UserSignInAuthenticator(network: URLSession.shared), tokenStore: FakeTokenStore())
        let auth = AuthService(signUp: signUp, signIn: signIn, tokenStore: InMemoryTokenStore())
        let exp = expectation(description: "sign")
        let sut = SignupViewModel(auth: auth, didSignIn: { exp.fulfill() })
        
        sut.name = "Joe"
        sut.password = password
        sut.email = email
        
        sut.signUp()
        
        waitForExpectations(timeout: 2)
    }
    
    func test_signup_shouldntCallCallbackIfCredentialsInvalid() {
        let email: Email = "invalid"
        let password: BasicPassword = makeValidPassword()
        let user = User(id: "123", email: email.value)
        let signUpStub = SignUpStub(result: .success(user))
        //let registerer = UserSignUpAuthenticator.stub(result: .success(user))
        //let login = UserSignInAuthenticator(network: URLSession.shared)
        let signIn = UserSignIn(client: HttpAPIClient.shared)
        let auth = AuthService(signUp: signUpStub, signIn: signIn, tokenStore: InMemoryTokenStore())
        
        let exp = expectation(description: "sign")
        exp.isInverted = true
        
        let sut = SignupViewModel(auth: auth, didSignIn: { exp.fulfill() })
        
        sut.password = password
        sut.email = email
        sut.signUp()
        
        waitForExpectations(timeout: 1)
    }
    
    
    
    

}

// MARK: Test Helpers
extension Singup {
    func makeAuth() -> AuthService {
        /*
        let auth = AuthService(registerer: UserSignUpAuthenticator(network: URLSession.shared), userLogin: UserSignInAuthenticator(network: URLSession.shared), tokenStore: FakeTokenStore())
        return auth
         */
        let tokenStore = SecureTokenStore(keychain: .standard)
        let client = HttpAPIClient.shared.tokenSender(store: tokenStore).tokenSaver(store: tokenStore)
        
        let userSignUp = UserSignUp(client: client)
        let userSignIn = UserSignIn(client: client)
        let auth = AuthService(signUp: userSignUp, signIn: userSignIn, tokenStore: tokenStore)
        return auth
    }
    
    func makeInputValidationSUT() -> (SignupViewModel, TestSpyNever<Bool>) {
        let sut = SignupViewModel(auth: makeAuth(), didSignIn: {})
        let spy = TestSpyNever(sut.$signUpformValid.eraseToAnyPublisher())
        sut.start()
        return (sut, spy)
    }
    
    private func makeValidEmail() -> Email {
        "test@test.com"
    }
    
    private func makeValidPassword() -> BasicPassword {
        "123456"
    }

}


