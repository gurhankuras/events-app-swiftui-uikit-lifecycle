//
//  CustomShape.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import Foundation
import SwiftUI

struct CustomShape: Shape {
    let corner: UIRectCorner
    let radii: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        return Path(path.cgPath)
    }
}
