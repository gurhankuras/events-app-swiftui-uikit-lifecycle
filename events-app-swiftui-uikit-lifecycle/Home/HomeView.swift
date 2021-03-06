//
//  Home.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeView.ViewModel
    //let categories: [String] = ["All", "Business", "Culture", "Music", "Conference"]
    let logger = AppLogger(type: HomeView.self)
    
    var body: some View {
        let _ = logger.i("body rebuild")
        VStack(spacing: 0) {
            HomeAppBar(user: viewModel.user,
                       onSignOut: viewModel.signOut,
                       onSignIn: { viewModel.onSignClick?() })
            remainder
            scroll
                .offset(y: -10)
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
    
    @ViewBuilder
    var scroll: some View {
        //if viewModel.loading {
         //   ScrollView {
         //       scrollBody
         //   }
        //}
        //else {
            CustomRefreshView(lottieFileName: "loading") {
                scrollBody
            } onRefresh: { refresher in
                print("REFRESING")
                viewModel.refresh(completion: {
                    print("COMPLETED")
                    DispatchQueue.main.async {
                        refresher.stopRefreshing?()
                    }
                })
            }
        //}
    }
    
    var scrollBody: some View {
        VStack {
            EventCategoriesView(viewModel.categories.map{ $0.name },
                                onTappedCategory: { category in viewModel.recentEventsViewModel.fetch(for: category) })
            
            RecentEventsCatalogView(viewModel: viewModel.recentEventsViewModel)
            NearEventsCatalogView(viewModel: viewModel.nearEventsViewModel)
            NearEventsCatalogView(viewModel: viewModel.nearEventsViewModel)
            
            /*
            EventCatalog(title: "Recently Created") {
                ForEach(viewModel.recentEventsViewModel.recentEvents) { event in
                    if viewModel.recentEventsViewModel.recentEventsLoading {
                        SkeletonEventCardView()
                    } else {
                        EventCardView(event: event)
                    }
                }
                .padding(.leading)

            }
             */

            /*
            EventCatalog(title: "popular-title") {
                ForEach(viewModel.nearEventsViewModel.nearEvents) { event in
                    if viewModel.nearEventsLoading {
                        SkeletonEventCardView()
                    } else {
                        EventCardView(event: event)
                    }
                }
                .padding(.leading)
            }
             */
            /*
            EventCatalog(title: "popular-title") {
                ForEach(viewModel.nearEventsViewModel.nearEvents) { event in
                    if viewModel.nearEventsLoading {
                        SkeletonEventCardView()
                    } else {
                        EventCardView(event: event)
                    }
                }
                .padding(.leading)
            }
             */
        }
        .padding(.bottom)
    }
}

struct RecentEventsCatalogView: View {
    @ObservedObject var viewModel: RecentEventsViewModel
    var body: some View {
        EventCatalog(title: "Recently Created") {
            ForEach(viewModel.recentEvents) { event in
                if viewModel.recentEventsLoading {
                    SkeletonEventCardView()
                } else {
                    EventCardView(event: event)
                }
            }
            .padding(.leading)
        }
    }
}

struct NearEventsCatalogView: View {
    @ObservedObject var viewModel: NearEventsViewModel
    var body: some View {
        EventCatalog(title: "popular-title") {
            ForEach(viewModel.nearEvents) { event in
                if viewModel.nearEventsLoading {
                    SkeletonEventCardView()
                } else {
                    EventCardView(event: event)
                }
            }
            .padding(.leading)
        }
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
