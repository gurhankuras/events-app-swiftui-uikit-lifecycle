//
//  ProfileViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI

class ProfileViewControllerFactory {
    let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }
    

    func controller(onTropiesIconClicked: @escaping () -> (), onVerificationClicked: @escaping () -> ()) -> UINavigationController {
        let darkModeSettings = DarkModeSettings()
        let settingsViewModel = SettingsViewModel(darkModeSettings: darkModeSettings)
        let profileViewModel = ProfileViewModel()
        
        profileViewModel.onTropiesClicked = onTropiesIconClicked
        profileViewModel.onVerificationClicked = onVerificationClicked
        
        let view = ProfileView(profileViewModel: profileViewModel, settingsViewModel: settingsViewModel)
        let profileController = UINavigationController(rootView: view)
        configureNavigationalOptions(navigationController: profileController)
        return profileController
    }
    
    func linkedinVerificationController(onVerified: @escaping () -> ()) -> UIViewController {
        let tokenStore = SecureTokenStore(keychain: .standard)
        let service = LinkedInService(client: HttpAPIClient.shared.tokenSender(store: tokenStore))
        let viewModel = LinkedInVerificationViewModel(service: service)
        viewModel.didVerified = onVerified
        let view = LinkedInView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        return vc
        //self.rootViewController.pushViewController(vc, animated: true)
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.tabBarItem = UITabBarItem(title: "profile-tab-item".localized(), image: UIImage(systemName: "person.fill"), tag: 4)
    }
}
