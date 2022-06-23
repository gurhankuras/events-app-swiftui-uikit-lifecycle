//
//  RecentEventsViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/15/22.
//

import Foundation
import os

class RecentEventsViewModel: ObservableObject {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: RecentEventsViewModel.self))
    var onEventSelected: ((EventCatalogCardViewModel) -> ())?

    init(eventService: EventFetcher) {
        self.eventService = eventService
    }
    
    @Published var recentEvents: [EventCatalogCardViewModel] = []
    @Published var recentEventsLoading = false

    let eventService: EventFetcher
    func fetch(for category: EventCategoryType) {
        recentEventsLoading = true
        eventService.fetch(for: .recentlyCreated, by: category, ascending: false) { [weak self] result in
            switch result {
            case .success(let remoteEvents):
                DispatchQueue.main.async {
                    self?.recentEvents = remoteEvents.map({
                        return .init($0, select: {[weak self] vm in self?.onEventSelected?(vm)})
                    })
                }
            case .failure(let error):
                BannerService.shared.show(icon: .failure, title: error.localizedDescription, action: .close)
                Self.logger.debug("\(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self?.recentEventsLoading = false
            }
        }
    }
}
