//
//  LinkedInService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/29/22.
//

import Foundation

struct LinkedInAccessTokenRequest: Encodable {
    let grantType: String
    let code: String
    let clientId: String
    let redirectURI: String
}

import os

struct LinkedInURLs {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LinkedInURLs.self))
    
    let clientId = "777k0v387w8dy0"
    let redirectURI = "https://www.linkedin.com/developers/tools/oauth/redirect"
    let baseURL = "https://www.linkedin.com"
    
    func code() -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = "/oauth/v2/authorization"
        let responseType = URLQueryItem(name: "response_type", value: "code")
        let clientId = URLQueryItem(name: "client_id", value: self.clientId)
        let state = URLQueryItem(name: "state", value: "D5gdw634Ghj")
        let redirectURI = URLQueryItem(name: "redirect_uri", value: self.redirectURI)
        let scope = URLQueryItem(name: "scope", value: "r_liteprofile r_emailaddress w_member_social")
        components?.queryItems = [responseType, clientId, state, redirectURI, scope]
        return components?.url
    }
    
    func accessToken(for code: String) -> URLRequest? {
        guard let url = URL(string: "http://localhost:5000/linkedin/accessToken") else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = LinkedInAccessTokenRequest(grantType: "authorization_code",
                                              code: code,
                                              clientId: self.clientId,
                                              redirectURI: self.redirectURI)
        
        let encodedBody: Data? = DispatchQueue.global(qos: .background).sync {
            guard let encodedBody = try? JSONEncoder().encode(body) else {
                Self.logger.error("Couldn't encode access token request body")
                return nil
            }
            return encodedBody
        }
        
        request.httpBody = encodedBody
        return request
    }
    
    
}

struct LinkedInSuccessMessage: Decodable {
    let message: String
}

class LinkedInService {
    enum Error: Swift.Error {
        case general(String)
    }
    
    let client: HttpClient
    let urls: LinkedInURLs = .init()
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func verify(with code: String, completion: @escaping (Result<LinkedInSuccessMessage, Swift.Error>) -> ()) {
        guard let request = urls.accessToken(for: code) else { return }
        
        client.request(request) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bundle):
                self?.handleVerifySuccess(bundle: bundle, completion: completion)
            }
        }
    }
    
    func handleVerifySuccess(bundle: HTTPResponseBundle, completion: @escaping (Result<LinkedInSuccessMessage, Swift.Error>) -> ()) {
        let response = bundle.response
        guard let data = bundle.data else {
            completion(.failure(URLError.init(.badServerResponse)))
            return
        }
        
        if response.statusCode == 200 {
            guard let decoded = try? JSONDecoder().decode(LinkedInSuccessMessage.self, from: data) else {
                completion(.failure(URLError.init(.badServerResponse)))
                return
            }
            completion(.success(decoded))
        }
        else {
            completion(.failure(Error.general("Something went wrong!")))
        }
    }
    
    
}
