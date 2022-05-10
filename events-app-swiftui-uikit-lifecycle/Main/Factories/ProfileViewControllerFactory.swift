//
//  ProfileViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import Foundation
import UIKit
import SwiftUI


struct ProfileActions {
    var onTropiesClicked: (() -> Void)?
}

class ProfileViewControllerFactory {
    public weak var window: UIWindow?

    func controller(notificationService: NotificationService, actions: ProfileActions) -> UINavigationController {
        let darkModeSettings = DarkModeSettings(window: window)
        let settingsViewModel = SettingsViewModel(darkModeSettings: darkModeSettings)
        let profileViewModel = ProfileViewModel()
        
        profileViewModel.onTropiesClicked = actions.onTropiesClicked
        let blankController = UINavigationController(rootViewController: UIHostingController(rootView: ProfileView(profileViewModel: profileViewModel, settingsViewModel: settingsViewModel)))
        configureNavigationalOptions(navigationController: blankController)
        return blankController
    }
    
    private func configureNavigationalOptions(navigationController: UINavigationController) {
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
    }
}
