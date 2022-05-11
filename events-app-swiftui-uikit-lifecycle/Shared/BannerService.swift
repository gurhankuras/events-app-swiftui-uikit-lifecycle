//
//  BannerService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/11/22.
//

import Foundation
import UIKit
import SwiftUI


enum BannerAction {
    case close
    case custom(() -> ())
}

enum BannerIcon {
    case success
    case failure
}

class BannerService {
    static var banner: Banner?
    static var heightConstraint: NSLayoutConstraint?
    
    static func show(icon: BannerIcon, title: String, action: BannerAction) {
        //let v = UIView(frame: window.bounds)
        if (banner == nil) {
            let v = Banner(title: title)
            v.setTitle(title)
            v.setIcon(icon)
            v.closeCallback = {
                print("girdi")
                BannerService.dismiss()
            }
            
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

            window.layoutIfNeeded()

            heightConstraint?.constant = 100
            
            animate(forward: true, completion: nil)
            return
        }

        print(banner?.alpha)
        dismiss(completion: {_ in
            banner?.setTitle(title)
            banner?.setIcon(icon)
            heightConstraint?.constant = 100
            animate(forward: true, completion: nil)
        })
        
    }
    
    private static var window: UIWindow {
        UIApplication.shared.keyWindow!
    }
    
    static func dismiss(completion: ((Bool) -> ())? = nil) {
        
        heightConstraint?.constant = 0
        animate(forward: false, completion: completion)
    }
    
    private static func animate(forward: Bool, completion: ((Bool) -> ())?) {

        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            window.layoutIfNeeded()
            banner?.alpha = forward ? 1 : 0
        }, completion: completion)
    }
}
