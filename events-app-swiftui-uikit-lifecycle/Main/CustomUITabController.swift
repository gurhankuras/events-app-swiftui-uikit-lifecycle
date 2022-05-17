//
//  CustomUITabController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit


class CustomUITabController: UITabBarController, UITabBarControllerDelegate {
    var startNewEvent: (() -> ())?
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Deneme" {
            startNewEvent?()
            return false
        }
        return true
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        guard var viewControllers = viewControllers else {
            return
        }

        viewControllers.insert(getDummyNewEventController(), at: 2)
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    private func getDummyNewEventController() -> UIViewController {
        let vc = UIViewController()
        vc.title = "Deneme"
        let image = UIImage(systemName: "plus.circle")
        vc.tabBarItem = UITabBarItem(title: "Deneme", image: image, tag: 2)
        return vc
    }
}
