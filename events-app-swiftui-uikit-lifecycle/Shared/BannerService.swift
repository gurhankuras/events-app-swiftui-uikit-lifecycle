//
//  BannerService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/11/22.
//

import Foundation
import UIKit
import SwiftUI

class BannerService {
    private var banner: Banner?
    private var heightConstraint: NSLayoutConstraint?
    private var timer: Timer?
    
    private let dissmissAfterSeconds: TimeInterval = 3
    static let shared = BannerService()
    
    func show(icon: BannerIcon, title: String, action: BannerAction) {
        if (banner == nil) {
            setBannerFirstTime(icon: icon, title: title, action: action)
            heightConstraint?.constant = 100
            animate(forward: true) { [weak self] _ in
                guard let self = self else { print("noo"); return }
                self.dismiss(after: self.dissmissAfterSeconds)
            }
            return
        }

        // dismisses the banner if a banner is showed on screen and after
        // dismissing previous banner completes, shows a new banner
        dismiss(completion: { [weak self] _ in
            guard let self = self else { print("noo"); return }
            self.banner?.configure(text: title, icon: icon, action: action)
            self.heightConstraint?.constant = 100
            self.animate(forward: true) { _ in
                self.dismiss(after: self.dissmissAfterSeconds)
            }
        })
    }
    
    private func setBannerFirstTime(icon: BannerIcon, title: String, action: BannerAction) {
        let window = UIApplication.shared.keyWindow!
        let v = Banner()
        v.configure(text: title, icon: icon, action: action)
        banner = v
        v.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(v)
        
        heightConstraint = v.heightAnchor.constraint(equalToConstant: 0)
        let constraints = [
            v.topAnchor.constraint(equalTo: window.topAnchor),
            v.leftAnchor.constraint(equalTo: window.leftAnchor),
            v.rightAnchor.constraint(equalTo: window.rightAnchor),
            heightConstraint!
        ]
        NSLayoutConstraint.activate(constraints)

        // I dont want to animate constraints except height constraint
        window.layoutIfNeeded()
    }
    
    /// immediately remove banner with animation
    func dismiss(completion: ((Bool) -> ())? = nil) {
        timer?.invalidate()
        heightConstraint?.constant = 0
        animate(forward: false, completion: completion)
    }
    
    
    /// remove banner after n seconds later. internally used by `show`
    /// - Parameters:
    ///   - after: The number of seconds to past to dismiss banner
    private func dismiss(after seconds: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) {
            [weak self] timer in
            guard let self = self else { print("noo"); return }
            self.heightConstraint?.constant = 0
            self.animate(forward: false, completion: nil)
            timer.invalidate()
        }
        
    }
    
    /// called after constraint changes to animate the constraint change
    /// depend on `forward`parameter animates appear/dissapear animation
    /// - Parameters:
    ///    - forward: The direction of animation. animates appear/dissapear animation depend on the parameter. If true fades in banner otherwise fade out banner
    private func animate(forward: Bool, completion: ((Bool) -> ())?) {
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 10.0, options: .curveEaseIn,
                       animations: { [weak self] in
                            guard let self = self else { print("noo"); return }
                            self.banner?.superview?.layoutIfNeeded()
                            self.banner?.alpha = forward ? 1 : 0
                       }, completion: completion)
    }
}