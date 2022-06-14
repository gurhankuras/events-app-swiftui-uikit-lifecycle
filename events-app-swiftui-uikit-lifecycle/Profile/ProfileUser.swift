//
//  ProfileUser.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import Foundation

struct LinkedinInfo: Codable, Equatable {
    let expires: String
    
    var valid: Bool {
        return true
    }
}

struct ProfileUser: Identifiable, Codable, Equatable {
    let id: String
    let email: String
    let username: String
    let image: String
    
    let linkedin: LinkedinInfo?
}

extension ProfileUser {
    static var stub: Self {
        return .init(id: "1234", email: "gurhankuras@hotmail.com", username: "Gurhan", image: "", linkedin: nil)
    }
}
