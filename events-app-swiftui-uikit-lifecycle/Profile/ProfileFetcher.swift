//
//  ProfileFetcher.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import Foundation

protocol ProfileFetcher {
    func fetchProfile(with id: ProfileUser.ID, completion: @escaping (Result<ProfileUser, Error>) -> ())
}
