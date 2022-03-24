//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var user: User?
    var onEventSelection: (() -> Void)?
    var onSignClick: (() -> Void)?

    let auth: Auth
    init(auth: Auth) {
        self.auth = auth
        auth.userPublisher
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
    
    var events: [Event] {
        return Event.fakes(repeat: 5).map {
            Event(id: $0.id, title: $0.title, address: $0.address, date: $0.date, image: $0.image, select: onEventSelection)
        }
    }
    
    
    
    var isSignedIn: Bool {
        user != nil
    }
    
    func signOut() {
        auth.signOut()
    }
}
