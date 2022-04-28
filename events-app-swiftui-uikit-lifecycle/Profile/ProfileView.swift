//
//  ProfileView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileView: View {
    
    let profileViewModel: ProfileUserViewModel = .init(name: "Gurhan Kuras", username: "gurhankuras", image: "pikachu")
    @StateObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileHeader(profileViewModel: profileViewModel)
            SettingsView(settingsViewModel: settingsViewModel)
        }
        .background(Color.paleBackground)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(settingsViewModel: .init(darkModeSettings: .init(window: SceneDelegate.shared?.window)))
    }
}



