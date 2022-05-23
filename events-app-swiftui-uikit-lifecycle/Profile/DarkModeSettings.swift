//
//  DarkModeUseCase.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation
import UIKit

class DarkModeSettings {
    private enum Keys: String {
        case prefersSystemMode = "prefersSystemMode"
        case darkMode = "darkMode"
    }
    
    func set(darkMode: Bool) {
        UserDefaults.standard.setValue(darkMode, forKey: Keys.darkMode.rawValue)
        changeTheme(to: darkMode ? .dark : .light)
    }
    
    private func changeTheme(to mode: UIUserInterfaceStyle ) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = mode
        }
    }
    
    func set(prefersSystemMode: Bool) {
        UserDefaults.standard.setValue(prefersSystemMode, forKey: Keys.prefersSystemMode.rawValue)
        changeTheme(to: prefersSystemMode ? .unspecified : (isDarkMode ? .dark : .light))
    }
    
    var isDarkMode: Bool {
        return UserDefaults.standard.bool(forKey: Keys.darkMode.rawValue)
    }
    var prefersSystemMode: Bool {
        return UserDefaults.standard.bool(forKey: Keys.prefersSystemMode.rawValue)
    }
}
