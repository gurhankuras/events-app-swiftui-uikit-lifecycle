//
//  JWTGenerator.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/18/22.
//

import Foundation

import CryptoKit

/// For unit testing purposes only.
/// https://stackoverflow.com/questions/60290703/how-do-i-generate-a-jwt-to-use-in-api-authentication-for-swift-app


private extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

struct Header: Encodable {
    let alg = "HS256"
    let typ = "JWT"
}

struct Payload: Encodable {
    let id: String
    let email: String
    let iat: Double
    let exp: Double
}


func generateTestJWT(id: String, email: String, expirationDate: Date) -> String {
    let secret = "dummy-secret"
    let privateKey = SymmetricKey(data: Data(secret.utf8))

    let header = Header()
    let headerJSONData = try! JSONEncoder().encode(header)
    let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

    let payload = Payload(id: id, email: email, iat: Date().timeIntervalSince1970, exp: expirationDate.timeIntervalSince1970)
    let payloadJSONData = try! JSONEncoder().encode(payload)
    let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

    let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
    let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
    let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

    let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")

    return token
}

func generateTestJWT(payload: [String: Any], expirationDate: Date) -> String {
    let secret = "dummy-secret"
    let privateKey = SymmetricKey(data: Data(secret.utf8))

    let header = Header()
    let headerJSONData = try! JSONEncoder().encode(header)
    let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

    let extendedPayload = payload.merging(["iat": Date().timeIntervalSince1970, "exp": expirationDate.timeIntervalSince1970], uniquingKeysWith: {_, new in new})
    
    let payloadJSONData = try! JSONSerialization.data(withJSONObject: extendedPayload)
    let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

    let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
    let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
    let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

    let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")

    return token
}


// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
