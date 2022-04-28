//
//  SettingsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var prefersSystemMode: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    let darkModeSettings: DarkModeSettings
   
    init(darkModeSettings: DarkModeSettings) {
        
        self.darkModeSettings = darkModeSettings
        isDarkMode = darkModeSettings.isDarkMode
        prefersSystemMode = darkModeSettings.prefersSystemMode
        $isDarkMode.sink { isDark in
            darkModeSettings.set(darkMode: isDark)
        }
        .store(in: &cancellables)
        
        $prefersSystemMode.sink { prefers in
            darkModeSettings.set(prefersSystemMode: prefers)
        }
        .store(in: &cancellables)
      /*
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
       */
    }
    

    
}
