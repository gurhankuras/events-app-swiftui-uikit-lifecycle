//
//  SearchCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinator {
    var rootViewController = UINavigationController(rootViewController: UIViewController())
    private let factory: SearchViewControllerFactory
    
    init(factory: SearchViewControllerFactory) {
        self.factory = factory
    }
    
    func start() {
        rootViewController = factory.controller()
    }
}
