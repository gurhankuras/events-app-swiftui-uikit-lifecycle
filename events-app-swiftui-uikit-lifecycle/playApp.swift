//
//  playApp.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import Foundation
//
//  playApp.swift
//  play
//
//  Created by Gürhan Kuraş on 1/13/22.
//

import SwiftUI

@main
struct playApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    let notificationService = NotificationService(notificationCenter: UNUserNotificationCenter.current())
    let root = CompositionRoot()
    
    var body: some Scene {
        WindowGroup {
                ContentView()
            .accentColor(.appPurple)
            .environmentObject(notificationService)
            .environmentObject(root)
            .environmentObject(root.chat)
        }
    }
}
