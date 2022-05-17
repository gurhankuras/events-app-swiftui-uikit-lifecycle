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
    func controller(onClickedContinueButton: @escaping () -> ()) -> UINavigationController {
        let view = CreateEventView(onContinued: onClickedContinueButton)
        let vc = UIHostingController(rootView: view)
        return UINavigationController(rootViewController: vc)
    }
    
    func mapController() -> UIViewController {
        return MapViewController()
    }
}
