//
//  UIViewPreview.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/11/22.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13, *)
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    public let view: View
    
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    
}

#endif
