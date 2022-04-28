//
//  SettingsView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsViewModel: SettingsViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SettingsGroupView(groupName: "Content") {
                    VStack(alignment: .leading) {
                        SettingsTile(title: "Favorites", icon: "heart") {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold, design: .default))
                        }
                        
                        SettingsTile(title: "Downloads", icon: "arrow.down.circle") {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold, design: .default))
                        }
                        
                        
                    }
                }
                
                SettingsGroupView(groupName: "Content") {
                    VStack(alignment: .leading) {
                        SettingsTile(title: "Language", icon: "globe") {
                            HStack {
                                Text("Turkish")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .bold, design: .default))
                            }
                        }
                        SettingsTile(title: "Automatic (follow iOS setting)", icon: "gearshape") {
                            Toggle("", isOn: $settingsViewModel.prefersSystemMode)
                                .labelsHidden()
                              .tint(.blue)
                        }
                        if !settingsViewModel.prefersSystemMode {
                            SettingsTile(title: "Dark Mode", icon: "moon") {
                                Toggle("", isOn: $settingsViewModel.isDarkMode)
                                    .labelsHidden()
                                  .tint(.blue)
                            }
                        }
                    }
                }
                
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsViewModel: .init(darkModeSettings: .init(window: SceneDelegate.shared?.window)))
    }
}