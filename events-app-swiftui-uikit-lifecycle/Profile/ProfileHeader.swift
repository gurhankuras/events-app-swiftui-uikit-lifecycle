//
//  ProfileHeader2.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/1/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileHeader: View {
    let profileState: ProfileState
    let startLinkedinVerification: (() -> ())?
    let showAchievements: (() -> ())?
    
    var body: some View {
        VStack {
            navBar
            info
            editButton
        }
        .padding(.bottom)
        .background(.background)
    }
    
    @ViewBuilder var info: some View {
        switch profileState {
        case .initial:
            profileAvatar(image: "")
            HStack(spacing: 2) {
                nameText("-")
            }
            emailText("-")
        case .loading:
            Group {
                profileAvatar(image: "")
                HStack(spacing: 2) {
                    nameText(String(repeating: "X", count: 10))
                }
                emailText(String(repeating: "X", count: 18))
            }
            .redacted(reason: .placeholder)
        case .success(let profile):
            profileAvatar(image: profile.image)
            HStack(spacing: 2) {
                nameText(profile.name)
                if profile.isVerified {
                    verificationBadge
                }
            }
            emailText(profile.username)
        case .error:
            profileAvatar(image: "")
            HStack(spacing: 2) {
                nameText("-")
            }
            emailText("-")
        }
        
    }
    
    var navBar: some View {
        HStack {
            switch profileState {
            case let .success(user) where !user.isVerified:
                verifyLinkedinButton
            default:
                EmptyView()
            }
            
            Spacer()
            Image("trophy")
                .renderingMode(.template)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.appPurple)
                .padding()
                .onTapGesture {
                    showAchievements?()
                }
        }
        .padding(.horizontal, 5)
    }
    
    func profileAvatar(image: String?) -> some View {
        WebImage(url: URL(string: image ?? ""))
            .resizable()
            .placeholder(
                Image("no-image")
            )
            .scaledToFill()
            .size(75)
            .clipped()
            .clipShape(Circle())
            .onTapGesture {
                print(UserDefaults.standard.bool(forKey: "darkMode"))
            }
    }
    
    func nameText(_ name: String) -> some View {
        Text(name)
            .fontWeight(.semibold)
    }
    
    func emailText(_ email: String) -> some View {
        Text(email)
            .font(.system(size: 13))
            .fontWeight(.medium)
            .foregroundColor(Color(.systemGray))
    }
    
    
    var editButton: some View {
        Button {
            
        } label: {
            HStack(alignment: .lastTextBaseline) {
                Text("profile-edit-button")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.appPurple)
        .clipShape(Capsule())
    }
    
    var verifyLinkedinButton: some View {
        Button {
            startLinkedinVerification?()
        } label: {
            Text("Verify Linkedin")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.appWhite)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.appPurple)
        .clipShape(Capsule())
    }
    
    var verificationBadge: some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundColor(.blue)
    }
    
   
}

struct ProfileHeader2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileHeader(profileState: .initial, startLinkedinVerification: {}, showAchievements: {})
                .previewDisplayName("Initial")
            ProfileHeader(profileState: .loading, startLinkedinVerification: {}, showAchievements: {})
                .previewDisplayName("Loading")
            ProfileHeader(profileState: .success(.stub(verified: true)), startLinkedinVerification: {}, showAchievements: {})
                .previewDisplayName("Verified")
            ProfileHeader(profileState: .success(.stub(verified: false)), startLinkedinVerification: {}, showAchievements: {})
                .previewDisplayName("Not Verified")
            ProfileHeader(profileState: .error, startLinkedinVerification: {}, showAchievements: {})
                .previewDisplayName("Error")
        }
        .previewLayout(.sizeThatFits)
        
    }
}
