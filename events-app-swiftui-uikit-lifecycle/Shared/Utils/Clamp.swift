//
//  Clamp.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/18/22.
//

import Foundation

func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    // -1 0 100 -> 0
    return Swift.max(min, Swift.min(value, max))
}
