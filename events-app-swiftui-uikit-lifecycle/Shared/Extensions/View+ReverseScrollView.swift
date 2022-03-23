//
//  View+ReverseScrollView.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation
import SwiftUI

struct ReverseScrollViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func reverseScroll() -> some View {
        modifier(ReverseScrollViewModifier())
    }
}
