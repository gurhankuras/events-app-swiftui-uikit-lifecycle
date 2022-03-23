//
//  NotificationService.swift
//  play
//
//  Created by Gürhan Kuraş on 2/11/22.
//

import Foundation
import UserNotifications
import UIKit


protocol NotificationServiceProtocol {
    func requestPermission()
    func send()
}


extension NotificationService: NotificationServiceProtocol {
    
    func requestPermission() {
        let  current = UNUserNotificationCenter.current()
        current.getNotificationSettings { [weak self] settings in
            guard let self = self else {
                return;
            }
            
            switch settings.authorizationStatus {
            case .notDetermined:
                current.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: self.permissionHandler)
            case .denied:
                self.logger.d("DENIED")
                self.openApplicationSettings()
            case .authorized:
                self.logger.d("AUTHORITEZ")
            default:
                self.logger.d("switch default case: \(settings.authorizationStatus)")
            }
        }
    }
    
    
    private func permissionHandler(success: Bool, error: Error?) {
        if success {
            print("All set")
        }
        else if let error = error {
            print(error.localizedDescription)
        }
        print("girdi")
    }
    
    private func openApplicationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
         }
        DispatchQueue.main.async { [weak self] in
            guard UIApplication.shared.canOpenURL(url) else {
                self?.logger.e("url cannot be opened!")
                return
            }
            
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    func send() {
        let content = UNMutableNotificationContent()
        content.title = "Adnan"
        content.subtitle = "Bilemiyorum ki"
        content.userInfo["deneme"] = "gurhan"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            print("Tamamlandi")
        }
    }
    
}


class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let logger = AppLogger(type: NotificationService.self)
    private let notificationCenter: UNUserNotificationCenter
    
    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
        super.init()
        self.notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let deneme = response.notification.request.content.userInfo["deneme"] else {
            completionHandler()
            return
        };
        print(deneme)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            print(userInfo)
            completionHandler([.banner])
       }
}
