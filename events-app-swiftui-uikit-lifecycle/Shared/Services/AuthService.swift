//
//  Authenticater.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import Combine

class AuthService {
    enum AuthStatus {
        case loggedIn(User)
        case errorOccurred(Error)
        case unauthorized
    }
    
    private let logger = AppLogger(type: AuthService.self)
    let userPublisher = CurrentValueSubject<AuthStatus, Never>(.unauthorized)
    var cancellable: AnyCancellable?
    
    private let tokenStore: TokenStore
    private let signUp: UserSignUp
    private let signIn: UserSignIn
    
    init(signUp: UserSignUp, signIn: UserSignIn, tokenStore: TokenStore) {
        self.signUp = signUp
        self.tokenStore = tokenStore
        self.signIn = signIn
    }
    
    func register(email: Email, password: Password) -> Void {
        signUp
            .signUp(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.logger.d("FETCHED USER SUCCESSFULLY")
                    DispatchQueue.main.async {
                        self?.userPublisher.send(.loggedIn(user))
                    }
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    DispatchQueue.main.async {
                        self?.userPublisher.send(.errorOccurred(error))
                    }
                }
            }
    }
    
    func login(email: Email, password: Password) {
            signIn
            .login(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.userPublisher.send(.loggedIn(user))                        
                    }
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    DispatchQueue.main.async {
                        self?.userPublisher.send(.errorOccurred(error))
                    }
                }
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
