//
//  DarkModeUseCase.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation

class ToggleDarkMode {
    func execute() {
        SceneDelegate.shared?.window!.overrideUserInterfaceStyle = SceneDelegate.shared?.window!.overrideUserInterfaceStyle == .dark ? .light : .dark
    }
}
