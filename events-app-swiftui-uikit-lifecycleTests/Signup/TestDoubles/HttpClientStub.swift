//
//  JsonPostNetworkStub.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation
@testable import events_app_swiftui_uikit_lifecycle

class HttpClientStub: HttpClient {
    let result: Result<ResponseBundle, Error>
    
    init(result: Result<ResponseBundle, Error>) {
        self.result = result
    }
    
    func request(_ request: URLRequest, completion: @escaping (Result<ResponseBundle, Error>) -> Void) {
        switch result {
        case .success(let bundle):
            completion(.success(bundle))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
