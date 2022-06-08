//
//  ImageUrlFetcher.swift
//  play
//
//  Created by Gürhan Kuraş on 3/15/22.
//

import Foundation
import Combine


struct PresignedUrlInfo: Codable {
    let url: String
    let key: String
}

protocol URLFetcher {
    func fetch() -> AnyPublisher<URL, Error>
}

class PresignedURLFetcher: URLFetcher {
    enum PresignedURLFetcherError: Error {
        case badURL
        case badPresignedURL
        case failed(ErrorMessage)
        case other(Error)
    }
    
    let network: JsonGet
    
    init(network: JsonGet) {
        self.network = network
    }
    
    func fetch() -> AnyPublisher<URL, Error> {
        guard let url = URL(string: "http://\(hostName):\(port)/upload?key=gurhan") else {
            return Fail(error: URLError.init(.badURL)).eraseToAnyPublisher()
        }
        
        return network.get(url: url)
            .tryMap({ data in
                let info = try JSONDecoder().decode(PresignedUrlInfo.self, from: data)
                
                guard let presignedUrl = URL(string: info.url) else {
                    throw PresignedURLFetcherError.badPresignedURL
                }
                return presignedUrl
            })
            
            .eraseToAnyPublisher()
    }
}

/*
@available(iOS 13.0, *)
extension PresignedURLFetcher {
    func fetch() -> AnyPublisher<URL, Error> {
        return Deferred {
            Future { [weak self] promise in
                self?.fetch { result in
                    switch result {
                    case .success(let url):
                        promise(.success(url))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
*/
