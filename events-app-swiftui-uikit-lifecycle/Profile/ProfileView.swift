//
//  ProfileView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

class ProfileViewModel: ObservableObject {
    var onTropiesClicked: (() -> ())?
    var onVerificationClicked: (() -> ())?
}

struct ProfileView: View {
    
    let profileUserViewModel: ProfileUserViewModel = .init(name: "Gurhan Kuras", username: "gurhankuras", image: "pikachu")
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileHeader(profileViewModel: profileUserViewModel,
                          onTropiesClicked: profileViewModel.onTropiesClicked,
                          verify: profileViewModel.onVerificationClicked
            )
            SettingsView(settingsViewModel: settingsViewModel)
        }
        .navigationBarHidden(true)
        .background(Color.background)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileViewModel: .init(), settingsViewModel: .init(darkModeSettings: .init()))
    }
}




