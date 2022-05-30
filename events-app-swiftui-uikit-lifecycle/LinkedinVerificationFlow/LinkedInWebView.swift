//
//  LinkedInWebView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/29/22.
//

import Foundation
import WebKit
import SwiftUI

struct LinkedInWebView: UIViewRepresentable {
    let url: URL
    let completion: (String) -> ()
    
    init(url: URL, completion: @escaping (String) -> ()) {
        self.url = url
        self.completion = completion
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.completion = completion
        return coordinator
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.navigationDelegate = context.coordinator
        //webView.loadHTMLString(htmlContent, baseURL: nil)
        //webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update")
    }
}

extension LinkedInWebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var showedContent: Bool = false
        var completion: ((String) -> ())?
        var code: String?
        var state: String?
        let service = LinkedInService(client: HttpAPIClient.shared)

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print(#function)
            
            guard let code = code,
                  let state = state else {
                return
            }
            
            completion?(code)
            
            //webView.load(URLRequest(url: URL(string: "")!))
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let components = URLComponents(string: navigationAction.request.url!.absoluteString)
            
            
            if let queries = components?.queryItems {
                code = queries.first(where: { query in query.name == "code" })?.value
                state = queries.first(where: { query in query.name == "state" })?.value
            }
            
            decisionHandler(.allow)
        }
        
        
    }

}
