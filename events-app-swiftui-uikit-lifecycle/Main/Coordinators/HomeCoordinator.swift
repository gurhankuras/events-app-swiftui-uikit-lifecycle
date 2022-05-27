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
    private let signFactory: SignViewControllerFactory
    
    init(factory: HomeViewControllerFactory, signFactory: SignViewControllerFactory) {
        self.factory = factory
        self.signFactory = signFactory
    }
    
    func start() {
        rootViewController = factory.controller(onEventClicked: { [weak self] event in self?.selectEvent(event) },
                                                onSignButtonClicked: { [weak self] in self?.sign() })
    }
    
    private func sign() {
        
        //SignCoordinator().start()
        let signingVc = signFactory.controller(onClosed: { [weak self] in self?.dismissSigning() })
        self.rootViewController.present(signingVc, animated: true)
    }
    
    private func dismissSigning() {
        rootViewController.dismiss(animated: true)
    }
    
    private func selectEvent(_ event: RemoteNearEvent) {
        let view = EventDetails(viewModel: .init(nearEvent: event))
        let vc = UIHostingController(rootView: view)
        self.rootViewController.pushViewController(vc, animated: true)
    }
}
