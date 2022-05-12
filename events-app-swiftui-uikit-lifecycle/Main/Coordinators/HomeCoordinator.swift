//
//  HomeCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class HomeCoordinator: Coordinator {
    var rootViewController: UINavigationController = UINavigationController(rootViewController: UIViewController())
    private let factory: HomeViewControllerFactory
    
    init(factory: HomeViewControllerFactory) {
        self.factory = factory
    }
    
    func start() {
        rootViewController = factory.controller(onEventClicked: { [weak self] in self?.clickEvent() },
                                                onSignButtonClicked: { [weak self] in self?.sign() })
    }
    
    private func sign() {
        let signingVc = factory.signController(onClosed: { [weak self] in self?.dismissSigning() })
        self.rootViewController.present(signingVc, animated: true)
    }
    
    private func dismissSigning() {
        rootViewController.dismiss(animated: true)
    }
    
    private func clickEvent() {
        let view = EventDetails()
        let vc = UIHostingController(rootView: view)
        self.rootViewController.pushViewController(vc, animated: true)
    }
}
