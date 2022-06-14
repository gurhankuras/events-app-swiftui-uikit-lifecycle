//
//  NewEventCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit
import SwiftUI
import os
import CoreLocation

/*
 
 {
     "title": "Hooks are a new addition in React 16.8",
     "at": "2022-08-13T16:05:56.707Z",
     "description": "As you can see in the example above, we have the ProductsViewModel fetching products from the remote server. Usually, we need only one Logger instance per feature. That’s why we declare it as a private and static constant. We can use subsystem and category parameters to filter logs in the future when we need to extract them. I usually use bundle identifier as subsystem and type name as a category. This approach allows me easily find logs from the required part of my app.Logger type provides us with functions to log a message with different emergency levels. For example, the trace function works as debug print, and the system doesn’t store it. The warning function allows us to log errors that are not fatal for our app, but we still need to know about them.",
     "latitude": 40.89733680580377,
     "longitute": 29.23255651669608,
     "image": "https://visit.cern/sites/default/files/inline-images/private-event-cropped.jpg",
     "address": {
         "city": "Istanbul",
         "district": "Pendik"
     }
 }
 */

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct NewEventRequest: Encodable {
    let title: String
    let at: Date
    let description: String
    let latitude: Double
    let longitute: Double
    let image: String
    let address: Address
    let categories: [EventCategoryType]

    
    struct Address: Encodable {
        let city: String
        let district: String
        let zipCode: String?
        let addressLine: String?
    }
}

struct RemoteNewEvent: Decodable, Identifiable {
    let id: String
    let title: String
    let at: Date
    //let createdAt: Date?
    let description: String
    let latitude: Double
    let longitute: Double
    let image: String
    let address: Address
    let categories: [EventCategoryType]
    
    struct Address: Decodable {
        let city: String
        let district: String
        let zipCode: String?
        let addressLine: String?
    }
}

struct NewEventBuilder {
    init(generalInfo: EventGeneralInfoStep?, address: NewEventBillingAddressStep?, coordinate: CLLocationCoordinate2D?) {
        self.generalInfo = generalInfo
        self.address = address
        self.coordinate = coordinate
    }
    
    init() {
        self.init(generalInfo: nil, address: nil, coordinate: nil)
    }
    
    var generalInfo: EventGeneralInfoStep?
    var address: NewEventBillingAddressStep?
    var coordinate: CLLocationCoordinate2D?
    
    func build() -> NewEventRequest? {
        guard let generalInfo = generalInfo,
              let address = address,
              let coordinate = coordinate else {
            return nil
        }
        
        return .init(title: generalInfo.title,
                     at: generalInfo.startAt.toGlobalTime(),
                     description: generalInfo.description,
                     latitude: coordinate.latitude,
                     longitute: coordinate.longitude,
                     image: "",
                     address: NewEventRequest.Address(city: address.city,
                                                      district: "Kartal",
                                                      zipCode: nil,
                                                      addressLine: nil),
                     categories: address.categories
                )
    }
}

class NewEventFlow: Flow {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: NewEventFlow.self))
    let factory: EventCreationViewControllerFactory
    weak var rootViewController: UINavigationController?
    let show: (UIViewController) -> ()
    let close: () -> ()
    /*
    var generalInfoStep: EventGeneralInfoStep?
    var addressStep: NewEventBillingAddressStep?
    var coordinate: New
    */
    var builder: NewEventBuilder = .init()
    init(factory: EventCreationViewControllerFactory, show: @escaping (UIViewController) -> (), close: @escaping () -> ()) {
        self.factory = factory
        self.show = show
        self.close = close
    }
    
    deinit {
        Self.logger.debug("NewEventCoordinator \(#function)")
    }
    
    func start() {
         showNewEventForm()
    }
    
    func showNewEventForm() {
        rootViewController = factory.controller(
            onNext: {[weak self] prevStep in
                guard let self = self else { return }
                //self.generalInfoStep = prevStep
                self.builder.generalInfo = prevStep
                let placeType = prevStep.placeType
                print("[WARN] \(placeType.rawValue)")
                switch placeType {
                case .physical, .both:
                    self.showAddressStep()
                    //self.showLocationSelectionFromMap()
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
    
    func showAddressStep() {
        let vm = NewEventAddressStepViewModel()
        let view = NewEventAddressStep(formViewModel: vm,
                        onClickedNext: { [weak self] form in
                            self?.builder.address = form
                            self?.showLocationSelectionFromMap((country: form.country, city: form.city))
                        },
                        dismiss: { [weak self] in
                            self?.rootViewController?.popViewController(animated: true)
                        })
        let vc = UIHostingController(rootView: view)
        self.rootViewController?.pushViewController(vc, animated: true)
    }
    
    func showLocationSelectionFromMap(_ address: (country: String, city: String)) {
        print("showLocationSelection")
        let vc = factory.mapController(address,
                    onNext: {[weak self] coordinate in
                        self?.builder.coordinate = coordinate
                        self?.handle()
                        //self?.showPreview()
                    })
        rootViewController?.pushViewController(vc, animated: true)
    }
    
    
    private func handle() {
        guard let request = builder.build() else { return }

        let store = SecureTokenStore(keychain: .standard)
        let client = HttpAPIClient.shared.tokenSender(store: store)
        let service = EventService(client: client)
        service.create(request) {[weak self] result in
            switch result {
            case .success(let remoteEvent):
                DispatchQueue.main.async {
                    self?.close()
                }
            case .failure(let error):
                if let error = error as? GenericNetworkError {
                    if case let .badResponse(data) = error {
                        let str = String(data: data, encoding: .utf8)
                        print(str ?? "")
                    }
                }
               
                Self.logger.debug("\(error.localizedDescription)")
            }
        }
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
