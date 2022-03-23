//
//  SceneDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let root = CompositionRoot()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.windowScene = windowScene
       
        let tabViewController = UITabBarController()
        
        let homeController = homeController()
        let chatController = chatController()
        let blankController = blankController()
        
        tabViewController.setViewControllers([homeController, blankController, chatController], animated: true)
        
        window?.rootViewController = tabViewController
        window?.makeKeyAndVisible()
    }
    
    func homeController() -> UINavigationController {
        let homeController = UINavigationController(rootViewController: UIHostingController(rootView: Home(viewModel: HomeViewModel())))
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        homeController.navigationBar.prefersLargeTitles = false
        homeController.navigationBar.isHidden = true
        return homeController
    }
    
    func chatController() -> UIViewController {
        let chatController = UIHostingController(rootView: RecentChatsView()
                                                    .environmentObject(root)
                                                    .environmentObject(root.chat))
        chatController.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.fill"), tag: 2)
        return chatController
    }
    
    func blankController() -> UIViewController {
        let blankController = UINavigationController(rootViewController: UIHostingController(rootView: Blank()))
        blankController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        return blankController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

