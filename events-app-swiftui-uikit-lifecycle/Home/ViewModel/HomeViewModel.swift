//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation


struct RemoteEvent: Decodable {
    let id: String
    let title: String
    let at: String
    let createdAt: String
}

protocol HttpClient {
    func request(_ request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void);
}

extension URLSession: HttpClient {
    func request(_ request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                completion(.failure(URLError.init(.badURL)))
                return
            }
            
            completion(.success((data, httpResponse)))
        }
        task.resume()
    }
}
struct PaginationOptions {
    let page: Int
    let pageSize: Int
}

extension PaginationOptions {
    public static func first(size: Int) -> Self {
        return PaginationOptions(page: 0, pageSize: size)
    }
}

/*
class ResponseResult<T: Decodable, E: Decodable> {
    private let error: E?
    private let result: T?
    
    
    
}
 */

enum ValidatorResult<T: Decodable, U: Decodable> {
    case success(T)
    case error(U)
}

class ResponseDecoder {
    private let data: Data
    private let response: HTTPURLResponse
    private let decoder: JSONDecoder
    private let validator: (HTTPURLResponse) -> Bool
    
    init(data: Data, response: HTTPURLResponse, decoder: JSONDecoder, validator: @escaping (HTTPURLResponse) -> Bool) {
        self.data = data
        self.response = response
        self.decoder = decoder
        self.validator = validator
    }
    
    func decode<T: Decodable, U: Decodable>() throws -> ValidatorResult<T, U>  {
        if validator(response) {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        }
        else {
            let decoded = try decoder.decode(U.self, from: data)
            return .error(decoded)
        }
    }
}

class EventAPIClient {
    let client: HttpClient
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func fetch(with options: PaginationOptions, completion: @escaping (Result<[RemoteEvent], Error>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:5290/events")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        client.request(request) { result in
            switch result {
            case .success(let (data, response)):
                let decoder = JSONDecoder.withFractionalSecondISO8601
                do {
                    if response.statusCode == 200 {
                        let remoteEvents = try decoder.decode([RemoteEvent].self, from: data)
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
}

class HomeViewModel: ObservableObject {
    @Published var user: User?
    var onEventSelection: (() -> Void)?
    var onSignClick: (() -> Void)?

    let auth: Auth
    let api: EventAPIClient
    
    init(auth: Auth, api: EventAPIClient) {
        self.auth = auth
        self.api = api
        auth.userPublisher
            .map({result in
                switch result {
                case .loggedIn(let user):
                    return user
                case .unauthorized:
                    return nil
                case .errorOccurred(_):
                    return nil
                }
            })
            .assign(to: &$user)
        
    }
    
    var events: [Event] {
        return Event.fakes(repeat: 5).map {
            Event(id: $0.id, title: $0.title, address: $0.address, date: $0.date, image: $0.image, select: onEventSelection)
        }
    }
    
    func load() {
        api.fetch(with: .first(size: 2)) { result in
            switch result {
            case .success(let events):
                print(events)
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    
    var isSignedIn: Bool {
        user != nil
    }
    
    func signOut() {
        auth.signOut()
    }
}
