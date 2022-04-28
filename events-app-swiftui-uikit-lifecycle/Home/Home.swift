//
//  Home.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI
import UserNotifications


struct Home: View {
    @StateObject var viewModel: HomeViewModel
    let logger = AppLogger(type: Home.self)
    
    var body: some View {
        let _ = logger.i("body rebuild")
        VStack(spacing: 0) {
            HomeAppBar(user: viewModel.user,
                       onSignOut: viewModel.signOut,
                       onSignIn: { viewModel.onSignClick?() }
            )
            EventRemainderView(count: 5, load: {viewModel.load()})
                .offset(y: -25)
                .foregroundColor(.white)
            
            HomeContentView(eventStubs: viewModel.events)
        }
        .background(Color.background)
        
        
    }
}



/*
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            Home(viewModel: .init())
                .preferredColorScheme(scheme)
        }
    }
}
 */
