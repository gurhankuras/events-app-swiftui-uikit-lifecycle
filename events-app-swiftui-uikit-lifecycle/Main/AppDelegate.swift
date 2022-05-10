//
//  AppDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        disableTransparentTabBar()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

// MARK: Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let deneme = response.notification.request.content.userInfo["deneme"],
              let sceneDelegate = sceneDelegate
        else {
            completionHandler()
            return
        }
        
        //sceneDelegate.tabController.selectedIndex = 1
        //sceneDelegate.chatViewController.present(sceneDelegate.chatUsersController(), animated: true)
        print(deneme)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.banner])
    }
    
    var sceneDelegate: SceneDelegate? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)
    }
}

// MARK: Global Appearance
extension AppDelegate {
    private func disableTransparentTabBar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().tintColor = .appPurple
        }
    }
}

// MARK: Orientation
extension AppDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return AppDelegate.orientationLock
     }
}
