//
//  SearchViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation
import Combine


class SearchViewModel {
    //var didLoad: (([SearchedEvent]) -> ())?
    let results = CurrentValueSubject<[SearchedEvent], Never>([])
    let query = CurrentValueSubject<String, Never>("")
    
    var cancellable: AnyCancellable?
    let engine: EventSearchEngine
    
    init(engine: EventSearchEngine) {
        self.engine = engine
        cancellable = query
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map({q in self.loadPublisher(for: q).receive(on: DispatchQueue.main)})
            .switchToLatest()
            .sink(receiveCompletion: { completion in
                print("Completed")
            }, receiveValue: { [weak self] results in
                //self?.didLoad?(results)
                self?.results.send(results)
            })
    }
    
    
    private func loadPublisher(for query: String) -> AnyPublisher<[SearchedEvent], Error> {
       print("girdi")
        return Deferred {
            Future { [weak self] promise in
                self?.engine.search(for: query, options: .init(pageNumber: 1, pageSize: 5)) { result  in
                    switch result {
                    case .success(let response):
                        promise(.success(response))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
                /*
                self?.load(for: query) { result in
                    
                }
                 */
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func load(for query: String, completion: @escaping (Result<[SearchedEvent], Error>) -> ()) {
        if query == "Gurhan" {
            completion(.success([query, "Gurhan2", "Gurhan3"].map({ title in
                return .init(id: title, at: Date(), image: "", title: title, description: "Event description", createdAt: Date(), latitude: 11, longitute: 22, address: .init(city: "Istanbul", district: "Kadikoy", addressLine: nil))
            })))
        }
        else {
            completion(.success([]))
        }
    }
}
