//
//  EventCategoryType+name.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/14/22.
//

import Foundation

extension EventCategoryType {
    var name: String {
        return self.rawValue.capitalizingFirstLetter()
    }
}
