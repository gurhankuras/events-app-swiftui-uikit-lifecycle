//
//  ProfileFetcherStub.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/1/22.
//

import Foundation


struct ProfileFetcherStub: ProfileFetcher {
    let result: Result<ProfileUser, Error>
    
    func fetchProfile(with id: ProfileUser.ID, completion: @escaping (Result<ProfileUser, Error>) -> ()) {
        switch result {
        case .success(let user):
            completion(.success(user))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension ProfileFetcherStub {
    static var error: ProfileFetcherStub {
        ProfileFetcherStub(result: .failure(DummyError()))
    }
    
    static var success: ProfileFetcherStub {
        ProfileFetcherStub(result: .success(.stub))
    }
}
