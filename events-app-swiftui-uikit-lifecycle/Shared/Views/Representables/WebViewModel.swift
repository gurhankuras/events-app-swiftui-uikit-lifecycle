//
//  WebViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/19/22.
//

import Foundation


import Foundation
import Combine

protocol WebViewNavigationDelegateViewModelBridge {
    var navigationEventPublisher: PassthroughSubject<WebViewNavigationEvent, Never> { get set }
    var request: URLRequest { get }
    func isAllowed(request: URLRequest) -> Bool
}

class WebViewModel: ObservableObject, WebViewNavigationDelegateViewModelBridge {
    private let allowedHosts: Set<String> = ["tr.sputniknews.com", "www.google.com"]
    
    var navigationEventPublisher = PassthroughSubject<WebViewNavigationEvent, Never>()
    //var showWebTitle = PassthroughSubject<String, Never>()
    //var showLoader = PassthroughSubject<Bool, Never>()
    //var valuePublisher = PassthroughSubject<String, Never>()
    let logger = AppLogger(type: WebViewModel.self)
    let request = URLRequest(url: URL(string: "https://www.google.com")!)
    
    func isAllowed(request: URLRequest) -> Bool {
        guard let host = request.url?.host else { return false }
        print(host)
        
        if !allowedHosts.contains(host) {
            return false
        }
        return true
    }
    
    deinit {
        logger.d("deinit")
    }
    // convenience functions for
    func goBack() {
        sendAction(.backward)
    }
    
    func goForward() {
        sendAction(.forward)
    }
    
    func reload() {
        sendAction(.reload)
    }
    
    func sendAction(_ event: WebViewNavigationEvent) {
        navigationEventPublisher.send(event)
    }
    
}

enum WebViewNavigationEvent {
    case backward, forward, reload
}

