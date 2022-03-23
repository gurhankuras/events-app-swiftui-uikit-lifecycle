//
//  Logs.swift
//  play
//
//  Created by Gürhan Kuraş on 2/12/22.
//

import Foundation
import SwiftUI

#if DEBUG
class AppLogger {
    enum LogType: Int {
        case none
        case initiliazation
        case debug
        case info
        case response
    }
    
    let type: Any
    static var level: LogType = .initiliazation
    
    init(type: Any) {
        self.type = type
    }
    
    
    func ini() {
        if Self.level.rawValue <= LogType.initiliazation.rawValue {
            self.log(logType: .initiliazation, log: "init")
        }
    }
    
    func d(_ log: Any) {
        if Self.level.rawValue <= LogType.debug.rawValue {
            self.log(logType: .debug, log: log)
        }
    }
    
     func i(_ log: Any) {
         if Self.level.rawValue <= LogType.info.rawValue {
             self.log(logType: .info, log: log)
        }
    }
    
     func e(_ log: Any) {
         if Self.level.rawValue <= LogType.response.rawValue {
             self.log(logType: .response, log: log)
        }
    }

    
    private func getEmoji(logType: LogType) -> String {
        switch logType {
        case .initiliazation:
            return "🔥"
        case .debug:
            return "🐛"
        case .info:
            return "🔍"
        case .response:
            return "❌"
        default:
            return ""
        }
    }
    
    static private func getEmoji(logType: LogType) -> String {
        switch logType {
        case .initiliazation:
            return "🔥"
        case .debug:
            return "🐛"
        case .info:
            return "🔍"
        case .response:
            return "❌"
        default:
            return ""
        }
    }
    
    func log(logType: LogType, log: Any) {
        let emoji = getEmoji(logType: logType)
        print("\(emoji) [\(type)] - \(log)")
    }
    
    static func log(logType: LogType, type: Any, log: Any) {
        let emoji = getEmoji(logType: logType)
        print("\(emoji) [\(type)] - \(log)")
    }
}
#endif
