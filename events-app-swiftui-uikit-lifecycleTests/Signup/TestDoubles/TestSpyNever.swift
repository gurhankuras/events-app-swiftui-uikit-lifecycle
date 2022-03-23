//
//  TestSpyNever.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import Foundation
import Combine

class TestSpyNever<T> {
    private(set) var values = [T]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<T, Never>, dropFirst: Bool = true) {
       cancellable = publisher
            .dropFirst(dropFirst ? 1 : 0)
            .sink { [weak self] value in
           self?.values.append(value)
        }
    }
}
