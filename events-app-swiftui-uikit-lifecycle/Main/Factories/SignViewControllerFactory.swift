//
//  SignViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/24/22.
//

import Foundation
import UIKit
import SwiftUI

class SignViewControllerFactory {
    let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func controller(onClosed: @escaping () -> ()) -> UIViewController {
        let viewModel = SignupViewModel(auth: authService, didSignIn: onClosed)
        let view = SignView(viewModel: viewModel, dismiss: onClosed)
        let controller = UIHostingController(rootView: view)
        return controller
    }
}
