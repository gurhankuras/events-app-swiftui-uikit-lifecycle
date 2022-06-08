//
//  AppDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit

import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        disableTransparentTabBar()
        
        
        
        return true
    }
    
    
}
/*
 //import FirebaseCore
 //import FirebaseMessaging
extension AppDelegate: MessagingDelegate {
    func setupPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerRemoteNotifications(application)
    }
    
    private func registerRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
}
 */

// MARK: Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let deneme = response.notification.request.content.userInfo["deneme"],
              sceneDelegate != nil
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
