//
//  HttpClient.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

struct HTTPResponseBundle {
    let data: Data?
    let response: HTTPURLResponse
}

struct HttpClientOptions {
    let contentType: String
}


class HttpAPIClient: HttpClient {
    let session: URLSession
    let options: HttpClientOptions
    
    init(session: URLSession, options: HttpClientOptions) {
        self.session = session
        self.options = options
    }
    
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponseBundle, Error>) -> Void) -> () {
        var req = request
        req.addValue(options.contentType, forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError.init(.badURL)))
                return
            }
            
            let bundle = HTTPResponseBundle(data: data, response: httpResponse)
            completion(.success(bundle))
        }
        task.resume()
    }
    
    func response() {
        
    }
}

extension HttpAPIClient {
    static var shared: HttpAPIClient {
        return HttpAPIClient(session: .shared, options: .init(contentType: "application/json"))
    }
}



