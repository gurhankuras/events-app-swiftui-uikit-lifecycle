//
//  View+SizeExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation
import SwiftUI

struct SizeViewExtension: ViewModifier {
    let size: CGFloat
    let alignment: Alignment
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size, alignment: alignment)
    }
}

extension View {
    func size(_ size: CGFloat, alignment: Alignment = .center) -> some View {
        modifier(SizeViewExtension(size: size, alignment: alignment))
    }
}
