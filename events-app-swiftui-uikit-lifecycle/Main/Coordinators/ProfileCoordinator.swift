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
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    private let factory: ProfileViewControllerFactory
    
    init(factory: ProfileViewControllerFactory) {
        self.factory = factory
    }
    
    func start() {
        rootViewController = factory.controller(onTropiesIconClicked: {[weak self] in self?.showAchievements() })
    }
    
    private func showAchievements() {
        let view = AchievementsView()
        let vc = UIHostingController(rootView: view)
        self.rootViewController.present(vc, animated: true, completion: nil)
    }
    
    
}
