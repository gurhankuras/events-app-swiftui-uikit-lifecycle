//
//  ChatViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//
import Foundation
import Combine
import SwiftUI



class ChatMessagesViewModel: ObservableObject {
    let logger = AppLogger(type: ChatMessagesViewModel.self)
    let service: RemoteChatMessageFetcher
    let apiClient: ChatMessagesApiClient
    let auth: Auth
    
    let chat: ChatRepresentation
    let scrollToEnd = PassthroughSubject<String, Never>()
    
    @Published var text: String = ""
    @Published var image: UIImage?
    @Published var loadingImage = false

    var cancellable: AnyCancellable?
    var sendMessageCancellable: AnyCancellable?

    // MARK: Loading Messages
    @Published var messages = [ChatMessage]()
    var page = 0
    var isLoading = false
    var canLoadMore = true
    var authCancellable: AnyCancellable?
    var currentUser: User?

    init(for chat: ChatRepresentation, service: RemoteChatMessageFetcher, apiClient: ChatMessagesApiClient, auth: Auth) {
        self.chat = chat
        self.service = service
        self.apiClient = apiClient
        self.auth = auth
        print("chat: \(chat)")
       
        authCancellable = auth.userPublisher.sink { [weak self] result in
            switch result {
            case .loggedIn(let user):
                self?.currentUser = user
                break
            default:
                self?.currentUser = nil
            }
        
        }
        logger.i(#function)
    }
    
    
    func belongsToCurrentUser(message: ChatMessage) -> Bool {
        guard let user = currentUser else { return false }
        return message.belongs(to: user)
    }
     
    
    var canSendMessage: Bool {
        return !text.trimmed().isEmpty || image != nil
    }
    
    deinit {
        logger.e(#function)
    }
    
    
    func send() {
        guard let currentUser = currentUser,
                let id = chat.roomId
        else {
            return
        }

        
        sendMessageCancellable = self.apiClient.send(message: .init(sender: currentUser.id, text: self.text, image: nil), roomId: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return  }
                switch completion {
                case .finished:
                    print("SUCCESS")
                    let msg: ChatMessage = .init(id: UUID().uuidString, sender: ChatUser(id: currentUser.id, name: "Demo", image: nil), message: self.text, timestamp: Date(), image: nil)
                    DispatchQueue.main.async {
                        
                        withAnimation {
                            self.messages.insert(msg, at: 0)
                        }
                        self.text = ""
                        self.image = nil
                        self.scrollToEnd.send(msg.id)
                    }
                case .failure(let error):
                    print(error)
                }
                self.sendMessageCancellable?.cancel()
            } receiveValue: { _ in
                
            }
    }
    
}

// MARK: Loading Messages
extension ChatMessagesViewModel {
    func loadMoreIfNeeded(item: ChatMessage?) {
        guard let item = item else {
            load()
            return
        }
        
        let thresholdIndex = messages.index(messages.endIndex, offsetBy: -10)
        if messages.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            load()
        }
    }
    
    func load() {
        guard let id = chat.roomId, !isLoading && canLoadMore else {
            print("page: \(page), isLoading: \(isLoading), canLoadMore: \(canLoadMore)")
            return
        }
        
        isLoading = true
        cancellable = service.fetch(for: id, at: page)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("FINISHED LOADING MESSAGES")
                case .failure(let error):
                    print("ERROR WHILE LOADING: \(error)")
                }
            } receiveValue: { [weak self] messages in
                guard let self = self else {
                    return
                }
                
                if messages.isEmpty {
                    self.canLoadMore = false
                    self.isLoading = false
                    self.cancellable?.cancel()
                    return
                }
                
                self.messages.append(contentsOf: messages)
                self.page += 1
                self.logger.d("Page: \(self.page)")
                self.cancellable?.cancel()
                self.isLoading = false
            }
    }
}
