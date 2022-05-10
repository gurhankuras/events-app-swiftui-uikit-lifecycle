//
//  ProfileCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class ProfileCoordinator: Coordinator {
    let factory: ProfileViewControllerFactory
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    let notificationService: NotificationService
    
    init(factory: ProfileViewControllerFactory, notificationService: NotificationService) {
        self.factory = factory
        self.notificationService = notificationService
    }
    
    func start() {
        var actions = ProfileActions()
        actions.onTropiesClicked = { [weak self] in
            self?.rootViewController.present(UIHostingController(rootView: AchievementsView()), animated: true, completion: nil)
        }
        rootViewController = factory.controller(notificationService: notificationService, actions: actions)
    }
    
    
}
