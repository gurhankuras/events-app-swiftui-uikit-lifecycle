//
//  PayService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

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

struct ThreeDSPaymentCompletionRequest: Encodable {
    /*
    {
        "conversationId": "123456",
        "conversationData": "",
        "paymentId": "1234633"
    }
     */
    let conversationId: String
    let conversationData: String?
    let paymentId: String
}


class ThreeDSPaymentService {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    // TODO: change signature of completion callback, replace bool with something else when done server-side fix
    func pay(with request: ThreeDSPaymentCompletionRequest, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let url = URL(string: "http://localhost:5110/payments/3ds/finish") else {
            completion(.failure(URLError.init(.badURL)))
            return
        }
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
    
        do {
            httpRequest.httpBody = try JSONEncoder().encode(request)
        } catch  {
            completion(.failure(error))
        }
        
        client.request(httpRequest) { result in
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
                    /*
                    if response.statusCode == 200 {
                        let content = try JSONDecoder().decode(ThreeDSPaymentResponse.self, from: data)
                        let base64EncodedHtmlContent = content.htmlContent
                        guard let html = base64EncodedHtmlContent.base64Decoded() else {
                            completion(.failure(URLError.init(.badServerResponse)))
                            return
                        }
                        
                        completion(.success(html))
                    }
                    completion(.failure(URLError.init(.badServerResponse)))
                     */
                    //completion(.success(String(data: data, encoding: .utf8) ?? "Cevirirken patladi") )
                    completion(.success(true))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        
        
        //
    }
    
    func startHandshake(completion: @escaping (Result<String, Error>) -> ()) {
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
                        guard let html = base64EncodedHtmlContent.base64Decoded() else {
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
