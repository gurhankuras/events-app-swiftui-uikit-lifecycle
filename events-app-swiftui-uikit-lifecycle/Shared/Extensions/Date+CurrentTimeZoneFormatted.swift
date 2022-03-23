//
//  Date+UTCExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 3/7/22.
//

import Foundation

extension Date {
    func formatted(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", timeZone: TimeZone = .current) -> String? {
        let format = DateFormatter()
        format.timeZone = timeZone
        format.dateFormat = dateFormat
        return format.string(from: self)
    }
}
