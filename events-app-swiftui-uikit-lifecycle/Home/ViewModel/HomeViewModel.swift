//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var user: User?

    init() {
        Auth.shared.userPublisher
            .map({result in
                switch result {
                case .loggedIn(let user):
                    return user
                case .unauthorized:
                    return nil
                case .errorOccurred(_):
                    return nil
                }
            })
            .assign(to: &$user)
    }
    
    
    
    var isSignedIn: Bool {
        user != nil
    }
    
    func signOut() {
        Auth.shared.signOut()
    }
}
