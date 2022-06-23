//
//  EventFetcher.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/15/22.
//

import Foundation
import os

struct PaginationOptions {
    let page: Int
    let pageSize: Int
}

extension PaginationOptions {
    public static func first(size: Int) -> Self {
        return PaginationOptions(page: 0, pageSize: size)
    }
}

struct QueryOptions {
    let limit: Int
    let sortByField: String
    let ascending: Bool
    let category: EventCategoryType
    init(category: EventCategoryType, sortByField: String, ascending: Bool = true, limit: Int = 5) {
        self.category = category
        self.sortByField = sortByField
        self.ascending = ascending
        self.limit = limit
    }
}

enum CatalogType {
    case recentlyCreated
    case popular
    case locationBased
}

class EventFetcher {
    let client: HttpClient

    init(client: HttpClient) {
        self.client = client
    }
    
    func fetch(for catalog: CatalogType,
               by category: EventCategoryType,
               ascending: Bool = true,
               completion: @escaping (Result<[RemoteNearEvent], Error>) -> ()
    )  {
        let field = mapSectionToSortField(catalog: catalog)
        guard let url = makeURL(options: QueryOptions(category: category, sortByField: field, ascending: ascending, limit: 5)) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        client.request(request) { result in
            switch result {
            case .success(let bundle):
                guard let data = bundle.data,
                      bundle.response.statusCode == 200 else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                let events = try! JSONDecoder.withFractionalSecondISO8601.decode([RemoteNearEvent].self, from: data)
                completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func mapSectionToSortField(catalog: CatalogType) -> String {
        switch catalog {
        case .recentlyCreated:
            return "CreatedAt"
        case .popular:
            return "Abc"
        case .locationBased:
            return "deneme"
        }
    }
    
    func makeURL(options: QueryOptions) -> URL? {
        var components = URLComponents()
        components.path = "/events/category"
        components.host = hostName
        components.port = port
        components.scheme = "http"
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(options.limit)),
            URLQueryItem(name: "ascending", value: options.ascending ? "true" : "false")
        ]
        components.queryItems?.append(URLQueryItem(name: "sortByField", value: options.sortByField))
        components.queryItems?.append(URLQueryItem(name: "category", value: options.category.rawValue))
        return components.url
    }
}
