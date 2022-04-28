//
//  SettingsView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsViewModel: SettingsViewModel = SettingsViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(settingsViewModel.groups) { group in
                    SettingsGroupView(group: group)
                }
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
