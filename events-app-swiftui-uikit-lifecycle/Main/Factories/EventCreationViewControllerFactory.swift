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
    
    func mapController(_ address: (country: String, city: String), onNext: @escaping (CLLocationCoordinate2D) -> ()) -> UIViewController {
        let provider = GeoJsonFileReader(address: address)
        let viewModel = MapStepViewModel(geoJsonProvider: provider)
        // TODO: when used constructor injection, i get runtime error. find the reason
        var vc = MapViewController()
        vc.viewModel = viewModel
        vc.onNext = onNext
        return vc
    }
}

class CreateEventViewController: UIHostingController<NewEventView> {
    deinit {
        print("CreateEventViewController \(#function)")
    }
}
