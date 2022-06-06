//
//  ProfileCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class ProfileFlow: Flow {
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    private let factory: ProfileViewControllerFactory
    
    init(factory: ProfileViewControllerFactory) {
        self.factory = factory
    }
    
    func start() {
        rootViewController = factory.controller(onTropiesIconClicked: {[weak self] in self?.showAchievements() },
                                                onVerificationClicked: {[weak self] in self?.verifyViaLinkedIn() })
    }
    
    private func showAchievements() {
        let view = AchievementsView()
        let vc = UIHostingController(rootView: view)
        self.rootViewController.present(vc, animated: true, completion: nil)
    }
    
    private func verifyViaLinkedIn() {
        let vc = factory.linkedinVerificationController(onVerified: { [weak self] in
            self?.rootViewController.popViewController(animated: true)
        })
        self.rootViewController.pushViewController(vc, animated: true)
    }
    
    
}
