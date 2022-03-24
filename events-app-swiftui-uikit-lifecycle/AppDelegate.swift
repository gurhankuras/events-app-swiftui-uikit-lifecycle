//
//  AppDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        disableTransparentTabBar()
        return true
    }
    
    private func disableTransparentTabBar() {
        if #available(iOS 15.0, *) {
            let appearence = UITabBarAppearance()
            appearence.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearence
            UITabBar.appearance().tintColor = .appPurple
        }
    }


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return AppDelegate.orientationLock
     }

}

