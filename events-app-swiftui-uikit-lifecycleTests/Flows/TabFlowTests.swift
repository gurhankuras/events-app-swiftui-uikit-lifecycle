//
//  TabFlowTests.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

class TabFlowTests: XCTestCase {

    weak var weakFlow: TabFlow?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakFlow)
    }
    
    func test_SUT_doNotLeakMemory() throws {
        let flow = makeSUT()
    }
}

extension TabFlowTests {
    func makeSUT() -> TabFlow {
        let client = HttpAPIClient.shared
        let signIn = UserSignIn(client: client)
        let signUp = UserSignUp(client: client)
        let store = InMemoryTokenStore()
        let auth = AuthService(signUp: signUp, signIn: signIn, tokenStore: store)
        let flow = TabFlow(homeFactory: HomeControllerFactory(auth: auth),
                           chatFactory: AuthenticatedChatViewControllerFactory(auth: auth),
                           profileFactory: ProfileViewControllerFactory(notificationService: .init(notificationCenter: .current()), authService: auth),
                           searchFactory: .init(),
                           createFactory: .init(),
                           signFactory: .init(authService: auth), authService: auth
        )
        
        weakFlow = flow
        return flow
    }

}
