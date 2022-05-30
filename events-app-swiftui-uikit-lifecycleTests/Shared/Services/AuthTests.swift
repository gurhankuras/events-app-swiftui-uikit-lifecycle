//
//  AuthTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/18/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class AuthTests: XCTestCase {
    let logger = AppLogger(type: AuthTests.self)
     

    func test_register_publishesUser_whenUserSignedUp() throws {
        let (email, password) = makeValidCredentials()
        let user = User(id: "123", email: email.value)
        let auth = makeRegisterSUT(registererResult: .success(user))
        
        let spy = TestSpyNever(auth.userPublisher.eraseToAnyPublisher())
        
        auth.register(name: "Joe", email: email, password: password)
        
        logger.i(spy.values)
        
        let result = try XCTUnwrap(spy.values.last)
        
        guard case let .loggedIn(wrappedUser) = result else {
            XCTFail("sadasd")
            return
        }
         
        XCTAssertEqual(spy.values.count, 1)
        XCTAssertEqual(wrappedUser.email, email.value)
    }
    
    func test_register_publishesError_whenCouldntUserSignedUp() throws {
        let (email, password) = makeValidCredentials()
        let auth = makeRegisterSUT(registererResult: .failure(SignupError.userAlreadyExists([ErrorMessage(message: "message")])))
        
        let spy = TestSpyNever(auth.userPublisher.eraseToAnyPublisher())
        
        auth.register(name: "Joe", email: email, password: password)
        //auth.register(email: email, password: password)
        
        logger.i(spy.values)
        
        let result = try XCTUnwrap(spy.values.last)
        guard case let .errorOccurred(error) = result else {
            XCTFail("should be error")
            return
        }
        
        XCTAssertEqual(spy.values.count, 1)
        XCTAssert(error is SignupError)
        XCTAssertEqual(error.localizedDescription , "message")
    }
    
    func test_register_publishesError_whenUserSignedIn() throws {
        let (email, password) = makeValidCredentials()
        let user = User(id: "123", email: email.value)
        let auth = makeLoginSUT(registererResult: .success(user))
        
        let spy = TestSpyNever(auth.userPublisher.eraseToAnyPublisher())
        
        auth.login(email: email, password: password)
        
        logger.i(spy.values)
        
        let result = try XCTUnwrap(spy.values.last)
        guard case let .loggedIn(wrappedUser) = result else {
            XCTFail("should be user")
            return
        }
        
        XCTAssertEqual(spy.values.count, 1)
        XCTAssertEqual(wrappedUser.email, email.value)
    }
    
    func test_register_publishesError_whenCouldntUserSignedIn() throws {
        let (email, password) = makeValidCredentials()
        let auth = makeLoginSUT(registererResult: .failure(NetworkError.response([ErrorMessage(message: "message")])))
        
        let spy = TestSpyNever(auth.userPublisher.eraseToAnyPublisher())
        
        auth.login(email: email, password: password)
        
        logger.i(spy.values)
        
        let result = try XCTUnwrap(spy.values.last)
        guard case let .errorOccurred(error) = result else {
            XCTFail("should be error")
            return
        }
        
        XCTAssertEqual(spy.values.count, 1)
        XCTAssert(error is NetworkError)
        XCTAssertEqual(error.localizedDescription , "message")
    }
    
    func test_signOut_deletesPersistedToken() {
        let (sut, tokenStore) = makeSignOutSUT()
        tokenStore.save(aJWTToken)
        sut.signOut()
        XCTAssertNil(tokenStore.get())
    }
    
    func test_trySignIn_publishesUser_whenTokenHasNotExpired() throws {
        let token = generateTestJWT(payload: ["id": "123", "email": "gurhankuras@hotmail.com"], expirationDate: Date().addingTimeInterval(100)
        )
        print(try decode(jwtToken: token))
        let (sut, store) = makeTrySignInSUT()
        store.save(token)
        let spy = TestSpyNever(sut.userPublisher.eraseToAnyPublisher())
        
        sut.trySignIn()
        
        print(spy.values)
        XCTAssertEqual(spy.values.count, 1)
    }
    
    func test_trySignIn_DoNotPublishUser_whenTokenHasExpired() throws {
        let token = generateTestJWT(payload: ["id": "123", "email": "gurhankuras@hotmail.com"], expirationDate: Date().addingTimeInterval(-100)
        )
        print(try decode(jwtToken: token))
        let (sut, store) = makeTrySignInSUT()
        store.save(token)
        let spy = TestSpyNever(sut.userPublisher.eraseToAnyPublisher())
        
        sut.trySignIn()
        
        guard case .unauthorized = sut.userPublisher.value else {
            XCTFail("state should have been unauthorized")
            return
        }
    
        XCTAssertEqual(spy.values.count, 0)
    }
    
   
    
    func test_trySignIn_CanNotSignIn_whenTokenHasNotRequiredFields() throws {
        let token = generateTestJWT(payload: ["email": "gurhankuras@hotmail.com"], expirationDate: Date().addingTimeInterval(100)
        )
        print(try decode(jwtToken: token))
        let (sut, store) = makeTrySignInSUT()
        store.save(token)
        let spy = TestSpyNever(sut.userPublisher.eraseToAnyPublisher())
        
        sut.trySignIn()
        
        guard case .unauthorized = sut.userPublisher.value else {
            XCTFail("state should have been unauthorized")
            return
        }
        XCTAssertEqual(spy.values.count, 0)
    }
    
    func test_trySignIn_deletesToken_whenTokenHasNotRequiredFields() throws {
        let token = generateTestJWT(payload: ["email": "gurhankuras@hotmail.com"], expirationDate: Date().addingTimeInterval(100)
        )
        print(try decode(jwtToken: token))
        let (sut, store) = makeTrySignInSUT()
        store.save(token)
        let spy = TestSpyNever(sut.userPublisher.eraseToAnyPublisher())
        
        sut.trySignIn()
        
        XCTAssertNil(store.get())
    }
    
    func test_trySignIn_deletesToken_whenTokenHasExpired() throws {
        let token = generateTestJWT(payload: ["id": "123", "email": "gurhankuras@hotmail.com"], expirationDate: Date().addingTimeInterval(-100)
        )
        print(try decode(jwtToken: token))
        let (sut, store) = makeTrySignInSUT()
        store.save(token)
        let spy = TestSpyNever(sut.userPublisher.eraseToAnyPublisher())
        
        sut.trySignIn()
     
        XCTAssertNil(store.get())
    }
}

// MARK: Fixture setup functions and utilities
extension AuthTests {
    func makeValidCredentials() -> (Email, BasicPassword) {
        let email: Email = "test@test.com"
        let password: BasicPassword = "12345"
        return (email, password)
    }
    
    func makeRegisterSUT(registererResult: Result<User, Error>) -> AuthService {
        let (email, password) = makeValidCredentials()
        let dummySignIn = DummyUserSignIn()
        let signUpStub = SignUpStub(result: registererResult)
        //let auth = AuthService(registerer: registerer, userLogin: login, tokenStore: FakeTokenStore())
        let auth = AuthService(signUp: signUpStub, signIn: dummySignIn, tokenStore: InMemoryTokenStore())
        return auth
    }
    
    var aJWTToken: String {
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyMzRhN2E5M2ZjM2QxMDQ3YzE5Y2YxZCIsImVtYWlsIjoidGV2ZmlrQGdtdGFpbC5jb20iLCJpYXQiOjE2NDc2MTc5NjIsImV4cCI6MTY0NzYyMTU2Mn0.hgifv4W3zojt_DDQGrs1qq71jB6Jc7HsaVMuj1SExtg"
    }
    
    
    func makeLoginSUT(registererResult: Result<User, Error>) -> AuthService {
        let (email, password) = makeValidCredentials()
        let signIn = DummyUserSignIn()
        let signUp = SignUpStub(result: registererResult)
        //let login = UserRegistererStub(result: registererResult)
        let auth = AuthService(signUp: signUp, signIn: signIn, tokenStore: InMemoryTokenStore())
        return auth
    }
    
    func makeSignOutSUT() -> (AuthService, TokenStore) {
        //let registerer = DummyUserlogin()
        let dummySignIn = DummyUserSignIn()
        let dummySignUp = DummyUserSignUp()
        let tokenStore = InMemoryTokenStore()
        let auth = AuthService(signUp: dummySignUp, signIn: dummySignIn, tokenStore: tokenStore)
        return (auth, tokenStore)
    }
    
    func makeTrySignInSUT() -> (AuthService, TokenStore) {
        let dummySignUp = DummyUserSignUp()
        let dummySignIn = DummyUserSignIn()
        let tokenStore = InMemoryTokenStore()
        let auth = AuthService(signUp: dummySignUp, signIn: dummySignIn, tokenStore: tokenStore)
        return (auth, tokenStore)
    }
}

extension Result {
    func getError() throws -> Failure {
        switch self {
        case .success(let success):
            return success as! Failure
        case .failure(let failure):
            return failure
        }
    }
}
