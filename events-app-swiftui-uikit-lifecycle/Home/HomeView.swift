//
//  Home.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeView.ViewModel
    let onEventSelected: (RemoteNearEvent) -> ()
    let categories: [String] = ["All", "Business", "Culture", "Music", "Conference"]
    let logger = AppLogger(type: HomeView.self)
    
    var body: some View {
        let _ = logger.i("body rebuild")
        VStack(spacing: 0) {
            HomeAppBar(user: viewModel.user,
                       onSignOut: viewModel.signOut,
                       onSignIn: { viewModel.onSignClick?() })
            remainder
            scroll
        }
        .background(Color.background)
        .navigationBarHidden(true)
    }
    
    @ViewBuilder var remainder: some View {
        EventRemainderView(count: 5) {
            viewModel.load()
        }
        .offset(y: -25)
        .foregroundColor(.white)
    }
    
    var scroll: some View {
        CustomRefreshView(lottieFileName: "loading") {
            VStack {
                EventCategoriesView(categories)
                EventCatalog(title: "popular-title") {
                    ForEach(viewModel.events) { event in
                        EventCardView(event: event, onClicked: viewModel.loading ? {_ in } : onEventSelected)
                            .padding(.leading)
                    }
                    .redacted(reason: viewModel.loading ? .placeholder : [])
                }

                EventCatalog(title: "popular-title") {
                    ForEach(viewModel.events) { event in
                        EventCardView(event: event, onClicked: viewModel.loading ? {_ in } : onEventSelected)
                            .padding(.leading)
                    }
                    .redacted(reason: viewModel.loading ? .placeholder : [])
                }
                EventCatalog(title: "popular-title") {
                    ForEach(viewModel.events) { event in
                        EventCardView(event: event, onClicked: viewModel.loading ? {_ in } : onEventSelected)
                            .padding(.leading)
                    }
                    .redacted(reason: viewModel.loading ? .placeholder : [])
                }
            }
            .padding(.bottom)
        } onRefresh: { refresher in
            viewModel.refresh(completion: {
                DispatchQueue.main.async {
                    refresher.stopRefreshing?()
                }
            })
        }
        .offset(y: -10)
        
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
