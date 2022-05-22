//
//  HttpClient.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/22/22.
//

import Foundation

protocol HttpClient {
    func request(_ request: URLRequest, completion: @escaping (Result<ResponseBundle, Error>) -> Void) -> ()
}
