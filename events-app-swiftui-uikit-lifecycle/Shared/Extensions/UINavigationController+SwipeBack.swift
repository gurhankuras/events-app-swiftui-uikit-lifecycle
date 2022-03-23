//
//  UINavigationController+SlideBackExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import Foundation
import UIKit

// when used custom back navigation button, swipe back gesture doesn't work
// this piece of code preserves the functionality
/// https://stackoverflow.com/questions/18946302/uinavigationcontroller-interactive-pop-gesture-not-working

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
