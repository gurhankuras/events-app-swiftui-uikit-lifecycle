//
//  ProfileHeader.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeader: View {
    let profileViewModel: ProfileUserViewModel
    let onTropiesClicked: (() -> Void)?
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("trophy")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.appPurple)
                    .padding()
                    .onTapGesture {
                        onTropiesClicked?()
                    }
            }
            WebImage(url: URL(string: profileViewModel.image))
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
            Text(profileViewModel.name)
                .fontWeight(.semibold)
            Text(profileViewModel.username)
                .font(.system(size: 13))
                .fontWeight(.medium)
                .foregroundColor(Color(.systemGray))
            Button {
                
            } label: {
                HStack(alignment: .lastTextBaseline) {
                    Text("Edit Profile")
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
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
        //.frame(height: 200)
        .background()
    }
}


struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader(
            profileViewModel: ProfileUserViewModel(
                name: "Gurhan Kuras",
                username: "gurhankuras",
                image: "gurhan"
            ), onTropiesClicked: nil
        )
            .previewLayout(.sizeThatFits)
    }
}
