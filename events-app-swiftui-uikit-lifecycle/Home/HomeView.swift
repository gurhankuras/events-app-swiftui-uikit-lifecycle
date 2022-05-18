//
//  Home.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI
import UserNotifications



// 40.886021244358034, longitude: 29.246035943842084
struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    let onEventSelected: (RemoteNearEvent) -> ()
    let categories: [String] = ["All", "Business", "Culture", "Music", "Conference"]
    let logger = AppLogger(type: HomeView.self)
    
    var body: some View {
        let _ = logger.i("body rebuild")
        VStack(spacing: 0) {
            HomeAppBar(user: viewModel.user,
                       onSignOut: viewModel.signOut,
                       onSignIn: { viewModel.onSignClick?() })
            EventRemainderView(count: 5) {
                viewModel.loadNearEvents(completion: {})
            }
            .offset(y: -25)
            .foregroundColor(.white)
            //ScrollView {
            CustomRefreshView(lottieFileName: "loading") {
                VStack {
                    EventCategoriesView(categories)
                    EventCatalog(title: "popular-title") {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event, onClicked: onEventSelected).padding(.leading)
                        }
                    }
                    EventCatalog(title: "popular-title") {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event, onClicked: onEventSelected).padding(.leading)
                        }
                    }
                    EventCatalog(title: "popular-title") {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event, onClicked: onEventSelected).padding(.leading)
                        }
                    }
                }
            } onRefresh: { refresher in
                viewModel.loadNearEvents(completion: {
                    refresher.stopRefreshing?()
                })
            }
            .offset(y: -10)
            

                
            //}
            //.padding(.bottom)
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
