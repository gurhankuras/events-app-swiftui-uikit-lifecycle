//
//  UIApplication+openAppUrl.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/14/22.
//

import Foundation
import UIKit

func openAppSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            print("Settings opened: \(success)") // Prints true
        })
    }
}
