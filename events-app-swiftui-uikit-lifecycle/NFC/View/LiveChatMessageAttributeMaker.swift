//
//  LiveChatMessageAttributeMaker.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/8/22.
//

import Foundation
import UIKit

protocol AttributedStringMaker {
    func make() -> NSAttributedString
}

struct LiveChatMessageAttributedStringMaker: AttributedStringMaker {
    typealias Attributes = [NSAttributedString.Key : Any]
    let message: LiveChatMessage
    
    func make() -> NSAttributedString {
        let timestampText = makeTimestamp("\(message.timestamp)")
        let usernameText = makeUsername("  \(message.username)")
        let messageText = makeMessage("  \(message.text)")
       
        let str = NSMutableAttributedString(attributedString: timestampText)
        str.append(usernameText)
        str.append(messageText)
        return str
    }
    
    private func makeTimestamp(_ timestamp: String) -> NSAttributedString {
        let attributes: Attributes =
        [
            .font: UIFont.systemFont(ofSize: 12, weight: .thin),
            .foregroundColor: UIColor.systemGray
        ]
        let attributesString = NSMutableAttributedString(string: timestamp, attributes: attributes)
        return attributesString
    }
    
    private func makeUsername(_ username: String) -> NSAttributedString {
        let attributes: Attributes =
        [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.messageUsernameColor
        ]
        let attributesString = NSMutableAttributedString(string: username, attributes: attributes)
        return attributesString
    }
    
    private func makeMessage(_ message: String) -> NSAttributedString {
        let attributes: Attributes =
        [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: UIColor.appTextColor
        ]
        let attributesString = NSMutableAttributedString(string: message, attributes: attributes)
        return attributesString
    }
}
