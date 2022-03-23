//
//  TestSpy.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation
import Combine

class TestSpy2<T, E: Error> {
    private(set) var values = [T]()
    private(set) var error: E?
    
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<T, E>) {
        cancellable = publisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.error = error
            case .finished:
                return
            }
        }, receiveValue: { [weak self] value in
            self?.values.append(value)
        })
    }
}
