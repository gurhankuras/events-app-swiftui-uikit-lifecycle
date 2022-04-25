//
//  ChatScroller.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/28/22.
//

import Foundation
import Combine

class ChatScroller {
    private let scroller: PassthroughSubject<String, Never>
    
    var publisher: AnyPublisher<String, Never> {
        return scroller.eraseToAnyPublisher()
    }
    
    init(scroller: PassthroughSubject<String, Never> = .init()) {
        self.scroller = scroller
    }
    
    func scrollTo(positionOf message: String) {
        scroller.send(message)
    }
}
