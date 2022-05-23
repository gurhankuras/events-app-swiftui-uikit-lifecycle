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
    let auth: AuthService
    var realTimeListener: RoomRealTimeListener
    var cancellable: AnyCancellable?
    var authCancellable: AnyCancellable?
    var onChatSelected: ((RoomViewModel) -> Void)?
    
    @Published var rooms = [RoomViewModel]()
    @Published var showingNewChatSelection = false
    @Published var showingOptions = false
    
    init(fetcher: ChatRoomFetcher, auth: AuthService, realTimeListener: RoomRealTimeListener) {
        self.fetcher = fetcher
        self.auth = auth
        self.realTimeListener = realTimeListener
        
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
        fetcher.fetch(for: user) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let rooms):
                let vms = rooms.map({ RoomViewModel(id: $0.id, imageUrl: $0.imageUrl, name: $0.name, message: $0.message, timestamp: $0.timestamp, lastSender: $0.lastSender, select: self?.onChatSelected)})
                DispatchQueue.main.async {
                    self?.rooms.append(contentsOf: vms)
                }
            }
        }
        /*
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
                let vms = rooms.map({ RoomViewModel(id: $0.id, imageUrl: $0.imageUrl, name: $0.name, message: $0.message, timestamp: $0.timestamp, lastSender: $0.lastSender, select: self?.onChatSelected)})
                self?.rooms.append(contentsOf: vms)
            })
         */
    }
}
