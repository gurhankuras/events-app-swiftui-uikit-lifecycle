//
//  ProfileView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI
struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ProfileHeader(profileState: profileViewModel.state,
                          startLinkedinVerification: profileViewModel.onVerificationClicked,
                          showAchievements: profileViewModel.onTropiesClicked,
                          onChangeAvatar: { [weak profileViewModel] image in profileViewModel?.changeAvatar(with: image) })
            SettingsView(settingsViewModel: settingsViewModel)
        }
        .navigationBarHidden(true)
        .background(Color.background)
    }
}

/*
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileViewModel: .init(profileFetcher: ProfileFetcherStub(result: .success(.stub)), authListener: ),
            settingsViewModel: .init(darkModeSettings: .init()))
    }
}


*/

