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
    weak var rootViewController: UINavigationController?
    let show: (UIViewController) -> ()
    let close: () -> ()
    
    init(factory: EventCreationViewControllerFactory,  show: @escaping (UIViewController) -> (), close: @escaping () -> ()) {
        self.factory = factory
        self.show = show
        self.close = close
    }
    
    deinit {
        print("NewEventCoordinator \(#function)")
    }
    
    func start() {
         showNewEventForm()
    }
    
    func showNewEventForm() {
        rootViewController = factory.controller(onClickedContinueButton: { [weak self] in
            
            self?.showLocationSelectionFromMap()
            print("onClickedContinueButton")
            
        }, dismiss: close)
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
