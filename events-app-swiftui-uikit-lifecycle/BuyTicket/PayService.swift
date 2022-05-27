//
//  PayService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

import Foundation

import Foundation

// MARK: - ThreeDSPaymentResponse
struct ThreeDSPaymentResponse: Codable {
    let htmlContent, status: String
    let errorCode, errorMessage, errorGroup: String?
    let locale: String
    let systemTime: Int
    let conversationID: String

    enum CodingKeys: String, CodingKey {
        case htmlContent, status, errorCode, errorMessage, errorGroup, locale, systemTime
        case conversationID = "conversationId"
    }
}


class PayService {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func submit(completion: @escaping (Result<String, Error>) -> ()) {
        guard let url = URL(string: "http://localhost:5110/payments/3ds/tickets") else {
            completion(.failure(URLError.init(.badURL)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        client.request(request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bundle):
                guard let response = bundle.response,
                      let data = bundle.data else {
                    completion(.failure(URLError.init(.badServerResponse)))
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let content = try JSONDecoder().decode(ThreeDSPaymentResponse.self, from: data)
                        let base64EncodedHtmlContent = content.htmlContent
                        guard let data = Data(base64Encoded: base64EncodedHtmlContent),
                              let html = String(data: data, encoding: .utf8) else {
                            completion(.failure(URLError.init(.badServerResponse)))
                            return
                        }
                        
                        completion(.success(html))
                    }
                    completion(.failure(URLError.init(.badServerResponse)))
                } catch  {
                    completion(.failure(error))
                }
                
                
                
            }
        }
    }
}
