//
//  HomeFlowTests.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle
import SwiftUI

protocol HomeDelegate {
    func didSelect(_ event: RemoteNearEvent)
    func dismissedSigning()
    func didAttemptSigning()
}

class HomeRouter: HomeDelegate {
    init(factory: HomeViewControllerFactory, signFactory: SignViewControllerFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.signFactory = signFactory
        self.navigationController = navigationController
    }
    
    let factory: HomeViewControllerFactory
    let signFactory: SignViewControllerFactory
    let navigationController: UINavigationController
    
    func didSelect(_ event: RemoteNearEvent) {
        let viewModel =  EventDetails.ViewModel(nearEvent: event)
        let view = EventDetails(viewModel: viewModel, dismiss: { [weak self] in self?.dismissEvent() }, buyTicket: { [weak self] in
            let viewModel = PaymentFormViewModel()
            let view = BillingAddressStepView(formViewModel: viewModel,
                                              onClickedNext: { [weak self] prevStep in self?.showCreditCardForm(with: prevStep)},
                                              dismiss: { [weak self] in self?.dismissEvent() }
            )
            let vc = UIHostingController(rootView: view)
            self?.navigationController.pushViewController(vc, animated: true)
        })
        self.navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
    
    private func dismissEvent() {
        self.navigationController.popViewController(animated: true)
    }
    
    // TODO: Move to a coordinator
    private func showCreditCardForm(with previousStep: BillingAddressStep) {
        let viewModel = CreditCardFormViewModel(billingAddressStep: previousStep)
        let view = CreditCardStepView(viewModel: viewModel,
                                      onNext: { [weak self] content in self?.showCheckout(htmlContent: content) },
                                      back: { [weak self] in self?.dismissEvent() })
        self.navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
    
    private func showCheckout(htmlContent: String) {
        DispatchQueue.main.async { [weak self] in
            let paymentService = ThreeDSPaymentService(client: HttpAPIClient.shared)
            let viewModel = CheckoutView.ViewModel(threeDSPaymentService: paymentService)
            let view = CheckoutView(viewModel: viewModel, htmlContent: htmlContent,
                                    dismiss: { self?.dismissEvent() },
                                    completion: { self?.navigationController.popToRootViewController(animated: true) })
            let vc = UIHostingController(rootView: view)
            self?.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func dismissedSigning() {
        navigationController.dismiss(animated: true)
    }
    
    func didAttemptSigning() {
        let signingVc = signFactory.controller(onClosed: { [weak self] in self?.dismissedSigning() })
        self.navigationController.present(signingVc, animated: true)
    }
    
    
}


class NonAnimatingNavigationController: UINavigationController {
    private(set) var modal: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        modal = viewControllerToPresent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        modal = nil
    }
}


class TestHomeViewControllerFactory: HomeViewControllerFactory {
    func controller(onEventClicked: @escaping (RemoteNearEvent) -> (), onSignButtonClicked: @escaping () -> ()) -> UINavigationController {
        return NonAnimatingNavigationController()
    }
}


class HomeFlowTests: XCTestCase {

    weak var weakFlow: HomeFlow?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakFlow)
    }
    
    func test_selectingEventPushesToStack() throws {
        let sut = makeNonAnimatingSUT()
        
        XCTAssertEqual(sut.navigationController.viewControllers.count, 0)

        sut.didSelect(.stub)
        
        XCTAssertEqual(sut.navigationController.viewControllers.count, 1)
        XCTAssertTrue(sut.navigationController.topViewController is UIHostingController<EventDetails>)
    }
    
    func test_openingSigningButtonPresentsModel() throws {
        let navigationSpy = NonAnimatingNavigationController()
        let sut = makeNonAnimatingSUT(navigationController: navigationSpy)
                
        XCTAssertNil(navigationSpy.modal)
        sut.didAttemptSigning()
        XCTAssertNotNil(navigationSpy.modal)
    }
    
    func test_dismissedSigning_dismissesModal() throws {
        let navigationSpy = NonAnimatingNavigationController()
        let sut = makeNonAnimatingSUT(navigationController: navigationSpy)
                
        sut.didAttemptSigning()
        XCTAssertNotNil(navigationSpy.modal)
        sut.dismissedSigning()
        XCTAssertNil(navigationSpy.modal)

    }
    
    
    
    
    func test_SUT_doNotLeakMemory() throws {
        let flow = makeSUT()
        
    }
}

extension UIViewController {

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

extension HomeFlowTests {
    func makeSUT() -> HomeFlow {
        let client = HttpAPIClient.shared
        let signIn = UserSignIn(client: client)
        let signUp = UserSignUp(client: client)
        let store = InMemoryTokenStore()
        let auth = AuthService(signUp: signUp, signIn: signIn, tokenStore: store)
        let flow = HomeFlow(factory: HomeControllerFactory(auth: auth), signFactory: .init(authService: auth))
        
        weakFlow = flow
        return flow
    }
    
    func makeNonAnimatingSUT(navigationController: UINavigationController = NonAnimatingNavigationController()) -> HomeRouter {
        let client = HttpAPIClient.shared
        let signIn = UserSignIn(client: client)
        let signUp = UserSignUp(client: client)
        let store = InMemoryTokenStore()
        let auth = AuthService(signUp: signUp, signIn: signIn, tokenStore: store)
        let flow = HomeRouter(factory: TestHomeViewControllerFactory(), signFactory: .init(authService: auth), navigationController: navigationController)
        
        return flow
    }

}
