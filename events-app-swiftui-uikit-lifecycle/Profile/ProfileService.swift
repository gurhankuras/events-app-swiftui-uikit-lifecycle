//
//  ProfileService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import Foundation
import os

class ProfileService: ProfileFetcher {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ProfileService.self))
    let client: HttpClient

    init(client: HttpClient) {
        self.client = client
    }
        
    func fetchProfile(with id: ProfileUser.ID, completion: @escaping (Result<ProfileUser, Error>) -> ()) {
        guard let req = prepareRequest() else {
            fatalError("")
            return
        }
        client.request(req) { result in
            switch result {
            case .success(let bundle):
                let response = bundle.response
                guard let data = bundle.data else {
                    completion(.failure(URLError.init(.badServerResponse)))
                    return
                }
                do {
                    if 200 ..< 300 ~= response.statusCode {
                        let user = try JSONDecoder.withFractionalSecondISO8601.decode(ProfileUser.self, from: data)
                        completion(.success(user))
                    }
                    else {
                        completion(.failure(DummyError()))
                    }
                } catch  {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func prepareRequest() -> URLRequest? {
        guard let url = URL(string: "http://\(hostName):\(port)/account/me") else { return nil }
        let request = URLRequest(url: url)
        return request
    }
}
