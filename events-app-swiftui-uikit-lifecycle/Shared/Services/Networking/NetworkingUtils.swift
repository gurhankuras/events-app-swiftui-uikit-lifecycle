//
//  NetworkingUtils.swift
//  play
//
//  Created by Gürhan Kuraş on 3/17/22.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

func makeJSONRequest(_ url: URL, with body: Data?, method: HTTPMethod, withExtraHeaders headers: [String: String] = [:]) -> URLRequest {
    var rq = URLRequest(url: url)
    rq.httpMethod = method.rawValue
    rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
    headers.forEach { key, value in
        rq.setValue(value, forHTTPHeaderField: key)
    }
    
    rq.httpBody = body
    return rq
}

