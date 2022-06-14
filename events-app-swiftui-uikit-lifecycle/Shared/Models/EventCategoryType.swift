//
//  EventCategoryType.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/14/22.
//

import Foundation

enum EventCategoryType: String, Codable {
    case business
    case culture
    case music
    case technology
}

extension EventCategoryType: CaseIterable {}
