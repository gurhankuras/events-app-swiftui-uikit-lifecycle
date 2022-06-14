//
//  Authenticater.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import Combine

protocol MainQueueDecorator {
    func guanteeMainThread(_ work: @escaping () -> ())
}

extension MainQueueDecorator {
    func guanteeMainThread(_ work: @escaping () -> ()) {
        if Thread.isMainThread {
            work()
        }
        else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

class SignUpMainQueueDispatchDecorator: MainQueueDecorator, EmailSignUp {
    let decoratee: EmailSignUp

    init(decoratee: EmailSignUp) {
        self.decoratee = decoratee
    }
    
    func signUp(with request: SignUpRequest, completion: @escaping (Result<User, Error>) -> ()) {
        decoratee.signUp(with: request) { [weak self] result in
            self?.guanteeMainThread {
                completion(result)
            }
        }
    }
}

class SignInMainQueueDispatchDecorator: MainQueueDecorator, EmailSignIn {
    let decoratee: EmailSignIn

    init(decoratee: EmailSignIn) {
        self.decoratee = decoratee
    }
    
    func login(email: Email, password: Password, completion: @escaping (Result<User, Error>) -> ()) {
        decoratee.login(email: email, password: password) { [weak self] result in
            self?.guanteeMainThread {
                completion(result)
            }
        }
    }
}

extension EmailSignUp {
    func mainQueueDispatch() -> SignUpMainQueueDispatchDecorator {
        return SignUpMainQueueDispatchDecorator(decoratee: self)
    }
}

extension EmailSignIn {
    func mainQueueDispatch() -> SignInMainQueueDispatchDecorator {
        return SignInMainQueueDispatchDecorator(decoratee: self)
    }
}

protocol AuthListener {
    var userPublisher: CurrentValueSubject<AuthStatus, Never> { get set }
}

enum AuthStatus {
    case loggedIn(User)
    case errorOccurred(Error)
    case unauthorized
}

class AuthService: AuthListener {
    
    private let logger = AppLogger(type: AuthService.self)
    var userPublisher = CurrentValueSubject<AuthStatus, Never>(.unauthorized)
    var cancellable: AnyCancellable?
    
    private let tokenStore: TokenStore
    private let signUp: EmailSignUp
    private let signIn: EmailSignIn
    
    init(signUp: EmailSignUp, signIn: EmailSignIn, tokenStore: TokenStore) {
        self.signUp = signUp
        self.tokenStore = tokenStore
        self.signIn = signIn
    }
    
    func register(name: String, email: Email, password: Password) -> Void {
        let request = SignUpRequest(name: name, emailAddress: email.value, password: password.value)
        signUp
            .signUp(with: request) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.logger.d("FETCHED USER SUCCESSFULLY")
                    self?.userPublisher.send(.loggedIn(user))
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    self?.userPublisher.send(.errorOccurred(error))
                }
            }
    }
    
    func login(email: Email, password: Password) {
            signIn
            .login(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.userPublisher.send(.loggedIn(user))
                case .failure(let error):
                    self?.logger.d("ERROR WHILE FETCING USER: \(error)")
                    self?.userPublisher.send(.errorOccurred(error))
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
              let image = decoded["image"] as? String,
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
        userPublisher.send(.loggedIn(User(id: id, email: email, image: image)))
    }
    
    
   
    
    
    
    
}
