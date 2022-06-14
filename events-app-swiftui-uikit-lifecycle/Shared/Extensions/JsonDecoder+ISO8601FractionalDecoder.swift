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
    
    static var withoutFractionalSecondISO8601: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    static var withCustomFractionalSecondISO8601: JSONDecoder {
        let decoder = JSONDecoder()
                
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        return decoder
    }
}
extension Formatter {
    static let iso8601withFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }()
}

extension JSONEncoder {
    
    static var withOldWay: JSONEncoder {
        let encoder = JSONEncoder()
        let formatter = Formatter.iso8601withFractionalSeconds
        encoder.dateEncodingStrategy = .formatted(formatter)
        return encoder
    }
    static var withCustomFractionalSecondISO8601: JSONEncoder {
        print("[BAK] BAK GİRDİ")
        let encoder = JSONEncoder()
                
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")!
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        print("[BAK]\(formatter.string(from: Date()))")
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            print("[BAK] \(date.toLocalTime())")
            let dateString = formatter.string(from: date.toLocalTime())
            print("[BAK]\(dateString)")
            try container.encode(dateString)
        })
        return encoder
    }
    
    static var withFractionalSecondISO8601: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
        
        print(dateFormatter.string(from: Date()))

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
