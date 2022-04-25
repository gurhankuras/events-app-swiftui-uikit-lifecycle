//
//  ChatUsersViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import Foundation
import Combine


protocol ChatUserFetcher {
    func fetch(q: String) -> AnyPublisher<[ChatUser], Error>
}

class ChatUsersViewModel: ObservableObject {
    let fetcher: ChatUserFetcher
    
    @Published var users: [ChatUser] = []
    @Published var query: String = ""
    
    var cancellable: AnyCancellable?
    let logger = AppLogger(type: ChatUsersViewModel.self)
    
    init(fetcher: ChatUserFetcher) {
        logger.i(#function)
        self.fetcher = fetcher
        cancellable = userPublisher
             .sink { completion in
                 switch completion {
                 case .failure(let error):
                     print(error)
                 case .finished:
                     print("FINSIHED")
                 }
             } receiveValue: { [weak self] chatUsers in
                 print("RECEIVED USERS \(chatUsers.count)")
                 self?.users = chatUsers
             }
    }
    deinit {
        logger.e(#function)
    }
    
    private var userPublisher: AnyPublisher<[ChatUser], Error> {
        $query
           .debounce(for: .seconds(0.6), scheduler: RunLoop.main)
           .removeDuplicates()
           .map { [weak self] q -> AnyPublisher<[ChatUser], Error> in
               guard let self = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
               return self.fetcher.fetch(q: q)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class RemoteChatUsersAdapter: ChatUserFetcher {
    var onSelect: ((ChatUser) -> Void)?
    let fetcher: RemoteChatUsersFetcher
    init(fetcher: RemoteChatUsersFetcher) {
        self.fetcher = fetcher
    }
    func fetch(q: String) -> AnyPublisher<[ChatUser], Error> {
        return fetcher.fetch(q: q)
            .map { [weak self] remoteUsers -> [ChatUser] in
                return remoteUsers.map({ ChatUser(id: $0.id, name: $0.name, image: $0.image ?? "no-image", select: self?.onSelect) })
        }
        .eraseToAnyPublisher()
    }
    
    
}


class RemoteChatUsersFetcher {
    let network: JsonGet
    
    init(network: JsonGet) {
        self.network = network
    }
    
    func fetch(q: String) -> AnyPublisher<[RemoteChatRoomUser], Error> {
        guard let url = URL(string: "http://gkevents.com/api/chat/users?q=\(q)") else {
            return Fail(error: URLError.init(.badURL)).eraseToAnyPublisher()
        }
        
        return network.get(url: url)
            .decode(type: [RemoteChatRoomUser].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
