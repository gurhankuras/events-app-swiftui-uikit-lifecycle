//
//  RemoteUser.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import Foundation


struct RemoteUser: Codable {
    let id: String
    let email: String
}

extension RemoteUser {
    var asUser: User {
        return User(id: id, email: email)
    }
}

struct User: Identifiable {
    let id: String
    let email: String
    let image: String?
    
    init(id: String, email: String, image: String? = nil) {
        self.id = id
        self.email = email
        self.image = image
    }
}
