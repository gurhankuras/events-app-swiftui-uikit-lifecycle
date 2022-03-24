//
//  HomeAppBar.swift
//  play
//
//  Created by Gürhan Kuraş on 2/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeAppBar: View {
    let user: User?
    let onSignOut: () -> Void
    @State var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let user = user  {
              HomeUserInfo(user: user)
            }
            
            HStack {
                Text("Find Amazing Events")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        print(KeychainWrapper.standard.string(forKey: "access-token", withAccessibility: .whenUnlocked) ?? "Access token not found")
                    }
                Spacer()
                if user != nil  {
                    SignOutButton(onTap: onSignOut)
                }
                else {
                    LoginButton()
                }
                
            }
            
            Text("222 events around you")
                .font(.footnote)
                .foregroundColor(.white)
                .opacity(0.8)
                .padding(.bottom)
            
            SearchBar(placeholder: "Find Events", text: $searchText)
                .foregroundColor(.primary)
            
        }
        .foregroundColor(.white)
        .padding(.horizontal, 25)
        .padding(.vertical)
        .padding(.bottom, 25)
        
        .background(
            LinearGradient(colors: [.appPurple, .appLightPurple], startPoint: .bottomLeading, endPoint: .topTrailing)
                .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
                .ignoresSafeArea()
             )
    }
}




struct HomeUserInfo: View {
    let user: User
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.image ?? "no-image"))
                .resizable()
                .placeholder(
                    Image("no-image")
                )
                .scaledToFill()
                .size(50)
                .clipped()
                .clipShape(Circle())
               
            VStack(alignment: .leading) {
                Text(formattedDate())
                    .font(.body)
                Text(user.email)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            Spacer()
            
            HStack {
                Image(systemName: "envelope")
                    .imageScale(.large)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 13)
                    .background(Color.appLightPurple)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                
                Image(systemName: "bell")
                    .imageScale(.large)
                    .padding(.all, 11)
                    .background(Color.appLightPurple)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                
            }
        }
        .padding(.bottom, 12)
    }
    
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current

        return formatter.string(from: Date())
    }
}

struct HomeAppBar_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            HomeAppBar(user: .init(id: "1", email: "gurhankuras"), onSignOut: {})
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        
    }
}




struct LoginButton: View {
    @State private var isPresented = false
    var body: some View {
        Image(systemName: "person.crop.circle.fill.badge.plus")
            .imageScale(.large)
            .padding(.horizontal, 10)
            .padding(.vertical, 13)
            .background(Color.appLightPurple)
            .cornerRadius(10)
            .shadow(radius: 1)
            .onTapGesture {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                SignView(isPresented: $isPresented)
            }
    }
}

struct SignOutButton: View {
    let onTap: () -> Void
    var body: some View {
        Image(systemName: "rectangle.portrait.and.arrow.right")
            .imageScale(.large)
            .padding(.horizontal, 10)
            .padding(.vertical, 13)
            .background(Color.appLightPurple)
            .cornerRadius(10)
            .shadow(radius: 1)
            .onTapGesture {
                print("signing out")
                onTap()
                
            }
    }
}
