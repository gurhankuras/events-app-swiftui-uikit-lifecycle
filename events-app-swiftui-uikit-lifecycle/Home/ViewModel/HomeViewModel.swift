//
//  HomeViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import Foundation
import os
import Combine

class ProfileImagePublisher {
    static let shared = ProfileImagePublisher()
    
    private init() {
        
    }
    let publisher = PassthroughSubject<Void, Never>()
}


extension HomeView {
    class ViewModel: ObservableObject {

        // MARK: Dependencies
        static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "HomeView.ViewModel")

        let auth: AuthService
        
        let recentEventsViewModel: RecentEventsViewModel
        let nearEventsViewModel: NearEventsViewModel
        
        let categories: [EventCategoryType] = EventCategoryType.allCases
        var onSignClick: (() -> Void)?
        var onEventSelected: ((EventCatalogCardViewModel) -> ())?
        var refreshCompletion: (() -> ())?


        // MARK: State
        @Published var user: User?
        @Published var selectedCategory: EventCategoryType = .sport
        @Published var loading = false
        
        
        var bag = Set<AnyCancellable>()
        
        init(auth: AuthService, recentEventsViewModel: RecentEventsViewModel, nearEventsViewModel: NearEventsViewModel) {
            self.auth = auth
            self.recentEventsViewModel = recentEventsViewModel
            self.nearEventsViewModel = nearEventsViewModel

            Self.logger.trace("HomeView.ViewModel init")
            auth.userPublisher
                .map({ result in
                    if case let .loggedIn(user) = result {
                        return user
                    }
                    return nil
                })
                
                .assign(to: &$user)
            
            
            $user
                .sink { [weak self] usr in
                    if let _ = usr {
                        self?.load()
                        return
                    }
                    self?.nearEventsViewModel.nearEvents = []
                }
                .store(in: &bag)
            
            nearEventsViewModel.$nearEventsLoading.combineLatest(recentEventsViewModel.$recentEventsLoading)
                .map { nearEventsLoading, recentEventsLoading in
                    nearEventsLoading || recentEventsLoading
                }
                .assign(to: &$loading)
          
            $loading
                .removeDuplicates()
                .sink { [weak self] loads in
                    if !loads {
                        self?.refreshCompletion?()
                        self?.refreshCompletion = nil
                    }
                }
                .store(in: &bag)
            
            ProfileImagePublisher.shared.publisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    /*
                    guard let self = self else { return }
                    let usr = self.user
                    self.user = usr
                     */
                    self?.objectWillChange.send()
                }
                .store(in: &bag)
        }
        
       
        
        ///  called by init function when first loading events
        ///  controls `loading` variable in turn this controls whether show skelaton event views or not
        func load() {
            Self.logger.trace("Loads events")
            nearEventsViewModel.nearEventsLoading = true
            if self.nearEventsViewModel.nearEvents.isEmpty {
                self.nearEventsViewModel.nearEvents = Array(repeating: .init(.stub), count: 4)
            }
            // TODO
            recentEventsViewModel.recentEventsLoading = true
            if self.recentEventsViewModel.recentEvents.isEmpty {
                self.recentEventsViewModel.recentEvents = Array(repeating: .init(.stub), count: 4)
            }
            self.nearEventsViewModel.loadNearEvents()
            recentEventsViewModel.fetch(for: selectedCategory)
            //self.fetch(for: selectedCategory)
        }
        
        /// called by pull-to-refresh. The difference between `load` and this function is that
        /// when refreshing we don't want to show skelaton views
        func refresh(completion: @escaping () -> ()) {
            refreshCompletion = completion
            Self.logger.trace("Attempted refresh for events")
            recentEventsViewModel.fetch(for: selectedCategory)
            nearEventsViewModel.loadNearEvents()
        }
        
        var isSignedIn: Bool {
            user != nil
        }
        
        func signOut() {
            auth.signOut()
        }
    }
}

