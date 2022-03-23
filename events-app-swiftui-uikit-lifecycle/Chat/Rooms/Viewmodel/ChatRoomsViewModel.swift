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
    var cancellable: AnyCancellable?
    var authCancellable: AnyCancellable?
    
    @Published var rooms = [RecentChat]()
    @Published var showingNewChatSelection = false
    @Published var showingOptions = false
    
    init(/*fetcher: ChatRoomFetcher*/) {
        self.fetcher = RemoteChatRoomFetcher(network: URLSession.shared.restrictedAccess())
        listenAuth()
    }
    
    private func listenAuth() {
        authCancellable = Auth.shared.userPublisher.sink { [weak self] result in
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
            }, receiveValue: { rooms in
                self.rooms.append(contentsOf: rooms)
            })
    }
}
