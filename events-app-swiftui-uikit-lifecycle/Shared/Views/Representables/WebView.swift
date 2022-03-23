//
//  WebView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/19/22.
//

import SwiftUI
import Combine
//import UIKit
import WebKit




struct WebView: UIViewRepresentable {
    private var viewModel: WebViewNavigationDelegateViewModelBridge
    
    init(viewModel: WebViewNavigationDelegateViewModelBridge) {
        self.viewModel = viewModel
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        webView.load(viewModel.request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update")
    }
    
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: WebViewNavigationDelegateViewModelBridge
        
        var valueSubscriber: AnyCancellable? = nil
        var webViewNavigationSubscriber: AnyCancellable? = nil
        private let logger = AppLogger(type: Coordinator.self)

        
        init(viewModel: WebViewNavigationDelegateViewModelBridge) {
            self.viewModel = viewModel
        }
      
        
        deinit {
            logger.i("deinit")
            valueSubscriber?.cancel()
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("didStartProvisionalNavigation")
    
            // when webview loaded first page subscribe to eventPublisher to listen user's refresh, navigate up and back
            // actions
            guard let _ = self.webViewNavigationSubscriber else {
                print("Buraya bir kez girmeli sadece")
                setupWebNavigationEventsSubscription(webView)
                return
            }
        }
        
        private func setupWebNavigationEventsSubscription(_ webView: WKWebView) {
            self.webViewNavigationSubscriber = self.viewModel.navigationEventPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { navigation in
                switch navigation {
                    case .backward:
                        if webView.canGoBack {
                            webView.goBack()
                        }
                    case .forward:
                        if webView.canGoForward {
                            webView.goForward()
                        }
                    case .reload:
                        webView.reload()
                }
            })
        }
        
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         
            guard viewModel.isAllowed(request: navigationAction.request) else {
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
        
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.title") { [weak self] (response, error) in
                if let error = error {
                    print("Error getting title")
                    print(error.localizedDescription)
                }
                
                guard let title = response as? String else {
                    return
                }
                
                self?.logger.d("title: \(title)")
                //self.parent.viewModel.showWebTitle.send(title)
            }
        }
    }
    
}
 
