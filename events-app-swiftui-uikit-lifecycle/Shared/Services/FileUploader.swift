//
//  FileUploader.swift
//  play
//
//  Created by Gürhan Kuraş on 3/15/22.
//

import Foundation
import Combine

class FileUploader {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    struct MyError: Error {}
    func upload(
            to url: URL,
            fromFile sourceUrl: URL,
            then handler: @escaping (Result<Bool, Error>) -> Void
        ) {
            var request = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalCacheData
            )
            
            request.httpMethod = "PUT"
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

            let task = session.uploadTask(with: request, fromFile: sourceUrl) { data, response, error in
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                guard let response = response,
                      let httpResponse = response as? HTTPURLResponse
                      else {
                    handler(.failure(MyError()))
                    return
                }
                
                guard (200..<399).contains(httpResponse.statusCode)  else {
                    print(httpResponse.statusCode)
                    handler(.failure(MyError()))
                    return
                }
                
                handler(.success(true))
            }

            task.resume()
        }
}


@available(iOS 13.0, *)
extension FileUploader {
    func upload(
            to url: URL,
            fromFile sourceUrl: URL
        ) -> AnyPublisher<Bool, Error>
    {
        return Deferred {
            Future { [weak self] promise in
                self?.upload(to: url, fromFile: sourceUrl) { result in
                    switch result {
                    case .success(let ok):
                        promise(.success(ok))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
