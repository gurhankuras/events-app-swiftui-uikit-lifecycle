//
//  SignupViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import Foundation
import Combine
import SwiftUI


class SignupViewModel: ObservableObject {
    @Published var email: Email = ""
    @Published var name: String = ""
    @Published var password: BasicPassword = ""
    @Published var error: String = ""
    @Published var signUpformValid: Bool = false
    @Published var signInformValid: Bool = false
    
    
    
    let didSignIn: () -> Void
    
    private let logger = AppLogger(type: SignupViewModel.self)
    private let auth: AuthService
    private var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        logger.e(#function)
    }
    
    init(auth: AuthService, didSignIn: @escaping () -> Void) {
        self.auth = auth
        self.didSignIn = didSignIn
        start()
    }
    
    func start() {
        $email.combineLatest($password, $name)
            .map { email, password, name in
                email.isValid && password.isValid && !name.isEmpty
            }
            .assign(to: &$signUpformValid)
        $email.combineLatest($password)
            .map { email, password in
                email.isValid && password.isValid
            }
            .assign(to: &$signInformValid)
    }
    
   
    func signUp() {
        listenUserSigningActivity()
        guard email.isValid && password.isValid else { return }
        auth.register(name: name, email: email, password: password)
    }
    
    func login() {
        listenUserSigningActivity()
        guard email.isValid && password.isValid else { return }
        auth.login(email: email, password: password)
    }
    
    private func listenUserSigningActivity() {
        self.cancellable = auth.userPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            
            .sink(receiveValue: { [weak self] status in
                switch status {
                case .unauthorized:
                    break
                case .errorOccurred(let error):
                    self?.error = error.localizedDescription
                    self?.logger.d("BASARISIZ \(error)")
                case .loggedIn(_):
                    self?.clearTextInputs()
                    self?.didSignIn()
                    break
               
                }
                self?.cancellable = nil
            })
    }
    
    
    
    func dismissError() {
        DispatchQueue.main.async { [weak self] in
            self?.error = ""
        }
    }
    
    func clearTextInputs() {
        self.email.reset()
        self.password.reset()
    }
}


extension String {
    func trimmed() -> String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
