//
//  EventCreator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import Foundation
import UIKit


protocol EventCreator {
    func create(_ event: NewEventRequest, completion: @escaping (Result<RemoteNewEvent, Error>) -> ())
}

enum GenericNetworkError: Error {
    case unauthenticated
    case unauthorized
    case server
    case badResponse(Data)
    case unknown
}

class EventService: EventCreator {
    let client: HttpClient
    var fileUploader: FileUploader2
    var image: UIImage?
    
    init(client: HttpClient, fileUploader: FileUploader2) {
        self.client = client
        self.fileUploader = fileUploader
    }
    
    
    func create(_ event: NewEventRequest, completion: @escaping (Result<RemoteNewEvent, Error>) -> ()) {
        guard let image = image else {
            return
        }
        _create(event) { [weak self] result in
            switch result {
            case .success(let newEvent):
                self?.fileUploader.fileName = newEvent.id
                self?.fileUploader.fetch(for: "event", image: image, completion: { uploadResult in
                    switch uploadResult {
                    case .success(_):
                        completion(.success(newEvent))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func _create(_ event: NewEventRequest, completion: @escaping (Result<RemoteNewEvent, Error>) -> ()) {
        guard let httpRequest = makeRequest(event) else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        client.request(httpRequest) { result in
            switch result {
            case .success(let bundle):
                guard let data = bundle.data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                let status = bundle.response.statusCode
                if status == 201 {
                    do {
                        let remoteNewEvent = try JSONDecoder.withFractionalSecondISO8601.decode(RemoteNewEvent.self, from: data)
                        completion(.success(remoteNewEvent))
                    } catch {
                        completion(.failure(error))
                    }
                    //completion(.success(.init(id: "", title: "", at: .now, createdAt: .now, description: "", latitude: 15, longitute: 14, image: "", address: .init(city: "", district: "", zipCode: "", addressLine: ""))))
                }
                else {
                    handleGenericHttpError(statusCode: status, data: data, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(_ event: NewEventRequest) -> URLRequest? {
        guard let url = URL(string: "http://\(hostName):\(port)/events") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder.withCustomFractionalSecondISO8601
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        */
        //let encoder = JSONEncoder.withCustomFractionalSecondISO8601
        
        guard let body = try? encoder.encode(event) else {
            return nil
        }
        print(String(data: body, encoding: .utf8))
        request.httpBody = body
        return request
    }
    
    
}

func handleGenericHttpError<T>(statusCode: Int, data: Data, completion: @escaping(Result<T, Error>) -> ()) {
    if statusCode == 400 {
        completion(.failure(GenericNetworkError.badResponse(data)))
    }
    else if statusCode == 401 {
        completion(.failure(GenericNetworkError.unauthenticated))
    }
    else if statusCode == 403 {
        completion(.failure(GenericNetworkError.unauthorized))
    }
    else if statusCode >= 500 {
        completion(.failure(GenericNetworkError.server))
    }
    else {
        completion(.failure(GenericNetworkError.unknown))
    }
}
