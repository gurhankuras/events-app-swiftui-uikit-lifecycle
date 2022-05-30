//
//  HomeCoordinator.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class HomeFlow: Flow {
    var rootViewController: UINavigationController = UINavigationController(rootViewController: UIViewController())
    var eventDetailsViewController: UINavigationController?
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
        let viewModel =  EventDetails.ViewModel(nearEvent: event)
        let view = EventDetails(viewModel: viewModel, dismiss: { [weak self] in self?.dismissEvent() }, buyTicket: { [weak self] in
            let viewModel = PaymentFormViewModel()
            let view = BillingAddressStepView(formViewModel: viewModel,
                                              onClickedNext: { [weak self] prevStep in self?.showCreditCardForm(with: prevStep)},
                                              dismiss: { [weak self] in self?.dismissEvent() }
            )
            let vc = UIHostingController(rootView: view)
            self?.rootViewController.pushViewController(vc, animated: true)
        })
        //eventDetailsViewController = UINavigationController(rootView: view)
        ///eventDetailsViewController?.modalPresentationStyle = .fullScreen
        //eventDetailsViewController?.isNavigationBarHidden = true
        self.rootViewController.pushViewController(UIHostingController(rootView: view), animated: true)
        //self.rootViewController.present(eventDetailsViewController!, animated: true)
    }
    
    // TODO: Move to a coordinator
    private func showCreditCardForm(with previousStep: BillingAddressStep) {
        let viewModel = CreditCardFormViewModel(billingAddressStep: previousStep)
        let view = CreditCardStepView(viewModel: viewModel,
                                      onNext: { [weak self] content in self?.showCheckout(htmlContent: content) },
                                      back: { [weak self] in self?.dismissEvent() })
        self.rootViewController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
    
    private func showCheckout(htmlContent: String) {
        DispatchQueue.main.async { [weak self] in
            let paymentService = ThreeDSPaymentService(client: HttpAPIClient.shared)
            let viewModel = CheckoutView.ViewModel(threeDSPaymentService: paymentService)
            let view = CheckoutView(viewModel: viewModel, htmlContent: htmlContent,
                                    dismiss: { self?.dismissEvent() },
                                    completion: { self?.rootViewController.popToRootViewController(animated: true) })
            let vc = UIHostingController(rootView: view)
            self?.rootViewController.pushViewController(vc, animated: true)
        }
    }
    
    private func dismissEvent() {
        self.rootViewController.popViewController(animated: true)
    }
}
