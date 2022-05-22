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
    @Published var password: BasicPassword = ""
    @Published var error: String = ""
    @Published var formValid: Bool = false
    
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
    }
    
    func start() {
        $email.combineLatest($password)
            .map { email, password in
                email.isValid && password.isValid
            }
            .assign(to: &$formValid)
    }
    
   
    func signUp() {
        listenUserSigningActivity()
        guard email.isValid && password.isValid else { return }
        auth.register(email: email, password: password)
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
