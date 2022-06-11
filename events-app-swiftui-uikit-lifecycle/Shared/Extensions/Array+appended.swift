//
//  Array+appended.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/11/22.
//

import Foundation

extension Array {
    func appended(_ newElements: Element...) -> Self {
        var a = self
        for el in newElements {
            a.append(el)
        }
        return a
    }
}
