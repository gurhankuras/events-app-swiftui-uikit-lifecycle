//
//  RemoteUserRegistererSpy.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation
import Combine
@testable import events_app_swiftui_uikit_lifecycle
class UserRegistererSpy {
    
    let authenticator: UserAuthenticator
    private(set) var error: Error?
    private(set) var user: User?
    
    var cancellable: AnyCancellable?
    
    init(authenticator: UserAuthenticator) {
        self.authenticator = authenticator
    }
    
    func handle(email: Email, password: Password) {
       cancellable = authenticator.handle(email: email, password: password)
            .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.error = error
            case .finished:
                break
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }
    }
    
    
}
