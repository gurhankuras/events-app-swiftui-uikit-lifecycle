//
//  NearEventFetcher.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/14/22.
//

import Foundation

struct GeoCoordinates {
    let latitude: Double
    let longitute: Double
}
class NearEventFinder {
    let client: HttpClient

    init(client: HttpClient) {
        self.client = client
    }
    
    func findEvents(around coordinates: GeoCoordinates, completion: @escaping (Result<[RemoteNearEvent], Error>) -> ()) {
        
        guard let request = makeRequest(coordinates) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        client.request(request) { result in
            switch result {
            case .success(let (data, response)):
                let decoder = JSONDecoder.withFractionalSecondISO8601
                do {
                    if response.statusCode == 200 {
                        let remoteEvents = try decoder.decode([RemoteNearEvent].self, from: data)
                        completion(.success(remoteEvents))
                    }
                    else {
                        let errorMessage = try decoder.decode([ErrorMessage].self, from: data)
                        completion(.failure(NetworkError.response(errorMessage)))
                    }
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(_ coordinates: GeoCoordinates) -> URLRequest? {
        let builtUrl = makeURL(with: coordinates)
        guard let url = builtUrl else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func makeURL(with coordinates: GeoCoordinates) -> URL? {
        var builder = URLComponents()
        builder.port = 5000
        builder.host = "localhost"
        builder.scheme = "http"
        builder.path = "/events"
        builder.queryItems = [.init(name: "latitute", value: String(coordinates.latitude)),
                              .init(name: "longitude", value: String(coordinates.longitute))]
        return builder.url
    }
}
