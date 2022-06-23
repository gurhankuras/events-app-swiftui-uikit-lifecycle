//
//  CustomUITabController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit

class TabbarDelegate: NSObject, UITabBarControllerDelegate {
    var onNewEventTabSelected: ((_ authenticated: Bool) -> ())?
    var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if isNewEventCreationTab(viewController) {
            if case .loggedIn(_) = authService.userPublisher.value {
                onNewEventTabSelected?(true)
            }
            else {
                onNewEventTabSelected?(false)
            }
            return false
        }
        HapticsService.shared.vibrate()
        
        return true
    }
    
    private func isNewEventCreationTab(_ viewController: UIViewController) -> Bool {
        viewController.title == "Deneme"
    }
}


class CustomUITabController: UITabBarController {
    private var _delegate: UITabBarControllerDelegate?
    
    init(delegate: UITabBarControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self._delegate = delegate
        self.delegate = _delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        vc.tabBarItem = UITabBarItem(title: "new-event-tab-item".localized(), image: image, tag: 2)
        return vc
    }
}



