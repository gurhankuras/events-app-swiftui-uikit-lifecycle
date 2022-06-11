//
//  EventCreationViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit
import SwiftUI
import MapKit


class EventCreationViewControllerFactory {
    func controller(onNext: @escaping (EventGeneralInfoStep) -> (), dismiss: @escaping () -> ()) -> UINavigationController {
        let viewModel = StepViewModel(next: onNext)
        let view = NewEventView(viewModel: viewModel, dismiss: dismiss)
        let vc = CreateEventViewController(rootView: view)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
    
    func mapController(onNext: @escaping (CLLocationCoordinate2D) -> ()) -> UIViewController {
        var vc = MapViewController()
        vc.onNext = onNext
        return vc
    }
}

class CreateEventViewController: UIHostingController<NewEventView> {
    deinit {
        print("CreateEventViewController \(#function)")
    }
}
