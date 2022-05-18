//
//  EventCreationViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit
import SwiftUI


class EventCreationViewControllerFactory {
    func controller(onClickedContinueButton: @escaping () -> (), dismiss: @escaping () -> ()) -> UINavigationController {
        let view = CreateEventView(onContinued: onClickedContinueButton, dismiss: dismiss)
        let vc = CreateEventViewController(rootView: view)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
    
    func mapController() -> UIViewController {
        return MapViewController()
    }
}

class CreateEventViewController: UIHostingController<CreateEventView> {
    deinit {
        print("CreateEventViewController \(#function)")
    }
}
