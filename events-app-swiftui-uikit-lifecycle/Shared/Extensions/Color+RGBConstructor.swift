//
//  Color.swift
//  play
//
//  Created by Gürhan Kuraş on 2/17/22.
//

import Foundation
import SwiftUI

extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
        let limit = 255.0
        self.init(red: r/limit, green: g/limit, blue: b/limit)
    }
    
    static let appWhite = Color(r: 242, g: 242, b: 242)
}
