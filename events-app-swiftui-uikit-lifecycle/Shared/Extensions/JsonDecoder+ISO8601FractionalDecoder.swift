//
//  JsonDecoder+ISO8601FractionalDecoder.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation

extension JSONDecoder {
    static var withFractionalSecondISO8601: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
