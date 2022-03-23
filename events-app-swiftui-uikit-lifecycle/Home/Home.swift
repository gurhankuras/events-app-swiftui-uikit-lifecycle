//
//  Home.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI
import UserNotifications


struct Home: View {
    @StateObject var viewModel = HomeViewModel()
    let logger = AppLogger(type: Home.self)
    var body: some View {
        let _ = logger.i("body rebuild")
        NavigationView {
            VStack(spacing: 0) {
                HomeAppBar(user: viewModel.user,
                           onSignOut: viewModel.signOut)
                EventRemainderView(count: 5)
                    .offset(y: -25)
                    .foregroundColor(.white)
                
                HomeContentView()
            }
            .background(Color.background)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}




struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            Home()
                .preferredColorScheme(scheme)
        }
    }
}



struct NoticationButtonGroup: View {
    @EnvironmentObject var notificationService: NotificationService
    
    var body: some View {
        Group {
            Button(action: {
                notificationService.requestPermission()
                
                
            }, label: {
                Text("Request Permission")
                    .foregroundColor(.white)
                    .padding()
                    //.background(.blue)
                    .clipShape(Capsule())
            })
                .padding(.bottom)
            
            
            
            Button(action: {
                notificationService.send()
                
            }, label: {
                Text("Schedule notification")
                    .foregroundColor(.white)
                    .padding()
                    //.background(.green)
                    .clipShape(Capsule())
            })
                .padding(.bottom)
        }
    }
}
