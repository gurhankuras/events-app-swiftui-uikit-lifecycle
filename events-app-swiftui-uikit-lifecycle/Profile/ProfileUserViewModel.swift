//
//  ProfileViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation


struct ProfileUserViewModel {
    
    
    let name: String
    let username: String
    let image: String
    let isVerified: Bool
    let isPlaceholder: Bool
    
    init(name: String, username: String, image: String, isVerified: Bool, isPlaceholder: Bool) {
        self.name = name
        self.username = username
        self.image = image
        self.isVerified = isVerified
        self.isPlaceholder = isPlaceholder
    }
    
    init(_ userProfile: ProfileUser) {
        self.name = userProfile.username
        self.username = userProfile.email
        self.image = ""
        self.isPlaceholder = false
        self.isVerified = userProfile.linkedin != nil
    }
    
}

extension ProfileUserViewModel {
    static func stub(verified: Bool) -> Self {
        return .init(name: "abdurrahmantaslar", username: "test@test.com", image: "", isVerified: verified, isPlaceholder: false)
    }
}


extension ProfileUserViewModel {
    static func error() -> ProfileUserViewModel {
        return ProfileUserViewModel(name: "-", username: "-", image: "", isVerified: true, isPlaceholder: true)
    }
    
    static func loading() -> ProfileUserViewModel {
        return ProfileUserViewModel(name: .init(repeating: "x", count: 10),
                                    username: .init(repeating: "x", count: 18),
                                    image: "",
                                    isVerified: true,
                                    isPlaceholder: true)
    }
}
