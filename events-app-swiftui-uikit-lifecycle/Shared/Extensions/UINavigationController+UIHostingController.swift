//
//  UINavigationController+UIHostingControllerExtension.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import SwiftUI
import UIKit

extension UINavigationController {
    convenience init<Content: View>(rootView: Content) {
        self.init(rootViewController: UIHostingController(rootView: rootView))
    }
}
