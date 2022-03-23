//
//  Authenticater.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import Combine

class Auth {
    enum AuthStatus {
        case loggedIn(User)
        case errorOccurred(Error)
        case unauthorized
    }
    
    private let logger = AppLogger(type: Auth.self)
    let userPublisher = CurrentValueSubject<AuthStatus, Never>(.unauthorized)
    var cancellable: AnyCancellable?
    
    private let tokenStore: TokenStore
    private let registerer: UserAuthenticator
    private let userLogin: UserAuthenticator
    
    static var shared: Auth {
        _shared
    }
    
    static private var _shared: Auth!
    
    static func configure(registerer: UserAuthenticator, userLogin: UserAuthenticator, tokenStore: TokenStore) {
        _shared = Auth(registerer: registerer, userLogin: userLogin, tokenStore: tokenStore)
    }
    
    init(registerer: UserAuthenticator, userLogin: UserAuthenticator, tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        self.registerer = registerer
        self.userLogin = userLogin
    }
    
    func register(email: Email, password: Password) -> Void {
        cancellable = registerer
            .handle(email: email, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.d("FETCHED USER SUCCESSFULLY")
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    self?.userPublisher.send(.errorOccurred(error))
                }
                self?.cancellable?.cancel()
                
            } receiveValue: { [weak self] user in
                self?.userPublisher.send(.loggedIn(user))
            }
    }
    
    func login(email: Email, password: Password) {
        cancellable = userLogin.handle(email: email, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    self?.userPublisher.send(.errorOccurred(error))
                }
                self?.cancellable?.cancel()

            } receiveValue: { [weak self] user in
                self?.userPublisher.send(.loggedIn(user))
            }

    }
    
    func signOut() {
        tokenStore.delete()
        userPublisher.send(.unauthorized)
    }
    
    private func decodedJwt() -> [String: Any]? {
        guard let accessToken = tokenStore.get() else {
            return nil
        }
        return try? decode(jwtToken: accessToken)
    }
    
    func trySignIn() {
        guard let decoded = decodedJwt(),
              let id = decoded["id"] as? String,
              let email = decoded["email"] as? String,
              let exp = decoded["exp"] as? Double
        else {
            // if token expired and token stored in keychain we delete invalid token
            tokenStore.delete()
            return
        }
        print("expiresAt: \(Date(timeIntervalSince1970: exp))")

        guard exp - Date().timeIntervalSince1970 > 1 else {
            logger.e("TOKEN EXPIRED!")
            tokenStore.delete()
            return
        }
        userPublisher.send(.loggedIn(User(id: id, email: email)))
    }
    
    
   
    
    
    
    
}
