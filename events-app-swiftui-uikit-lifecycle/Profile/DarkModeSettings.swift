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
    
    private weak var window: UIWindow?
    init(window: UIWindow?) {
        self.window = window
    }
    
    func set(darkMode: Bool) {
        UserDefaults.standard.setValue(darkMode, forKey: Keys.darkMode.rawValue)
        window?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
    
    func set(prefersSystemMode: Bool) {
        UserDefaults.standard.setValue(prefersSystemMode, forKey: Keys.prefersSystemMode.rawValue)
        window?.overrideUserInterfaceStyle = prefersSystemMode ? .unspecified : (isDarkMode ? .dark : .light)
    }
    
    var isDarkMode: Bool {
        return UserDefaults.standard.bool(forKey: Keys.darkMode.rawValue)
    }
    var prefersSystemMode: Bool {
        return UserDefaults.standard.bool(forKey: Keys.prefersSystemMode.rawValue)
    }
}
