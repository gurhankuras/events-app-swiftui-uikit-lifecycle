//
//  CheckoutView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

import Foundation
import UIKit
import WebKit
import SwiftUI

struct PaymentResultResponse: Decodable {
    let status: String
    let paymentId: String
    let conversationData: String?
    let conversationId: String
    let mdStatus: String
}

enum UrlEncodedFormDecodeError: String, Error  {
    case stringDecoding = "Couldn't decode data to utf-8 string"
}

func decodeFromUrlEncodedForm<T>(_ decodable: T.Type, from data: Data) throws -> T where T: Decodable {
    
    guard let str = String(data: data, encoding: .utf8) else {
        throw UrlEncodedFormDecodeError.stringDecoding
    }
    var components = URLComponents()
    components.percentEncodedQuery = str
    var fields: [String: Any] = [:]
    components.percentEncodedQueryItems?.forEach { item in
        fields[item.name] = item.value
    }
    
    let jsonData = try JSONSerialization.data(withJSONObject: fields)
    let res = try JSONDecoder().decode(T.self, from: jsonData)
    return res
}

struct CheckoutWebView: UIViewRepresentable {
    let htmlContent: String
    let completion: () -> ()
    
    init(htmlContent: String, completion: @escaping () -> ()) {
        self.htmlContent = htmlContent
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
    
        guard let url = URL(string: "https://google.com") else { return webView }
        let request = URLRequest(url: url)
        webView.loadHTMLString(htmlContent, baseURL: nil)
        webView.navigationDelegate = context.coordinator
        
        //webView.load(viewModel.request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update")
    }
}

extension CheckoutWebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var showedContent: Bool = false
        var completion: (() -> ())?
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print(#function)
            
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let urlStr = navigationAction.request.url?.absoluteString,
                urlStr == "https://www.merchant.com/callback" {
                if let body = navigationAction.request.httpBody {
                    let res = try! decodeFromUrlEncodedForm(PaymentResultResponse.self, from: body)
                    print(res)
                }
                
                completion?()
                completion = nil
            }
            decisionHandler(.allow)
        }
        
        
    }

}
