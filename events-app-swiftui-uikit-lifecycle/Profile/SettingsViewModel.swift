//
//  SettingsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = SceneDelegate.shared?.window!.overrideUserInterfaceStyle == .dark ? true : false
    var cancellable: AnyCancellable?
    
    let darkModeService: ToggleDarkMode = ToggleDarkMode()
    var groups: [SettingGroup] = []
    
    
    init() {
        cancellable = $isDarkMode.sink { darkMode in
            self.darkModeService.execute()
        }
        groups.append(contentsOf: [
            SettingGroup(section: "Content", settings: [
                .init(name: "Favorites", icon: "heart", type: .link({})),
                .init(name: "Downloads", icon: "arrow.down.circle", type: .link({ [weak self] in
                    self?.darkModeService.execute()
                })),
            ]),
            SettingGroup(section: "Preferences", settings: [
                .init(name: "Language", icon: "globe", type: .multiselect("Turkish")),
                .init(name: "Dark Mode", icon: "moon", type: .toggle(.constant(true)))
            ])
        ])
    }
    
    func toggleDarkMode() {
        
    }
    
}
