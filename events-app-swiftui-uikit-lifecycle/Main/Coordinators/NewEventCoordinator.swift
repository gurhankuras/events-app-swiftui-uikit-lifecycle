//
//  NewEventCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit

class NewEventCoordinator: Coordinator {
    let factory: EventCreationViewControllerFactory
    var rootViewController: UINavigationController?
    let show: (UIViewController) -> ()
    
    init(factory: EventCreationViewControllerFactory,  show: @escaping (UIViewController) -> ()) {
        self.factory = factory
        self.show = show
    }
    
    func start() {
         showNewEventForm()
    }
    
    func showNewEventForm() {
        rootViewController = factory.controller(onClickedContinueButton: { [weak self] in
            
            self?.showLocationSelectionFromMap()
            print("onClickedContinueButton")
            
        })
        guard let rootViewController = rootViewController else {
            return
        }

        show(rootViewController)
    }
    
    func showLocationSelectionFromMap() {
        print("showLocationSelection")
        let vc = factory.mapController()
        rootViewController?.pushViewController(vc, animated: true)
    }
}
