//
//  NewEventCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit

class NewEventFlow: Flow {
    let factory: EventCreationViewControllerFactory
    weak var rootViewController: UINavigationController?
    let show: (UIViewController) -> ()
    let close: () -> ()
    var generalInfoStep: EventGeneralInfoStep?
    
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
        rootViewController = factory.controller(
            onNext: {[weak self] prevStep in
                guard let self = self else { return }
                self.generalInfoStep = prevStep
                let placeType = prevStep.placeType
                print("[WARN] \(placeType.rawValue)")
                switch placeType {
                case .physical, .both:
                    self.showLocationSelectionFromMap()
                case .online:
                    /*
                    let vc = UIViewController()
                    vc.view.backgroundColor = .orange
                    self.rootViewController?.pushViewController(vc, animated: true)
                */
                    self.rootViewController?.dismiss(animated: true)
                }
            },
            dismiss: close)
        guard let rootViewController = rootViewController else {
            return
        }

        show(rootViewController)
    }
    
    func showLocationSelectionFromMap() {
        print("showLocationSelection")
        let vc = factory.mapController(onNext: {[weak self] _ in self?.showPreview() })
        rootViewController?.pushViewController(vc, animated: true)
    }
    
    private func showPreview() {
        self.rootViewController?.dismiss(animated: true)
        /*
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        self.rootViewController?.pushViewController(vc, animated: true)
         */
    }
}
