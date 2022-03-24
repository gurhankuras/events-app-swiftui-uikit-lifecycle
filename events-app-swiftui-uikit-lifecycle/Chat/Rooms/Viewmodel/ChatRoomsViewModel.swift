//
//  ChatRoomsViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 3/13/22.
//

import Foundation
import Combine

class ChatRoomsViewModel: ObservableObject {
    let fetcher: ChatRoomFetcher
    let auth: Auth
    var cancellable: AnyCancellable?
    var authCancellable: AnyCancellable?
    var onChatSelected: ((ChatRepresentation) -> Void)?
    
    
    @Published var rooms = [RecentChatViewModel]()
    @Published var showingNewChatSelection = false
    @Published var showingOptions = false
    
    init(fetcher: ChatRoomFetcher, auth: Auth) {
        self.fetcher = fetcher
        self.auth = auth
        listenAuth()
    }
    
    private func listenAuth() {
        authCancellable = auth.userPublisher.sink { [weak self] result in
            switch result {
            case .loggedIn(let user):
                self?.load(for: user)
                break
            default:
                self?.rooms = []
            }
        }
    }
    
    func load(for user: User) {
        cancellable?.cancel()
        cancellable = fetcher.fetch(for: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            }, receiveValue: { [weak self] rooms in
                let vms = rooms.map({ RecentChatViewModel(id: $0.id, imageUrl: $0.imageUrl, name: $0.name, message: $0.message, timestamp: $0.timestamp, lastSender: $0.lastSender, select: self?.onChatSelected)})
                self?.rooms.append(contentsOf: vms)
            })
    }
}
