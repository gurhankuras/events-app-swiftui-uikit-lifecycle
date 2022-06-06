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
    let authService: AuthService
    private var rootViewModel: ProfileViewModel?
    
    init(notificationService: NotificationService, authService: AuthService) {
        self.notificationService = notificationService
        self.authService = authService
    }
    

    func controller(onTropiesIconClicked: @escaping () -> (), onVerificationClicked: @escaping () -> ()) -> UINavigationController {
        let darkModeSettings = DarkModeSettings()
        let settingsViewModel = SettingsViewModel(darkModeSettings: darkModeSettings)
        let fetcher = ProfileService(client: HttpAPIClient.shared.tokenSender(store: SecureTokenStore(keychain: .standard)))
        let profileViewModel = ProfileViewModel(profileFetcher: fetcher, authListener: authService)
        rootViewModel = profileViewModel
        
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
        viewModel.didVerified = { [weak self] in
            DispatchQueue.main.async {
                self?.rootViewModel?.loadProfile()
                onVerified()
            }
        }
        let view = LinkedInView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        return vc
        //self.rootViewController.pushViewController(vc, animated: true)
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.tabBarItem = UITabBarItem(title: "profile-tab-item".localized(), image: UIImage(systemName: "person.fill"), tag: 4)
    }
}
