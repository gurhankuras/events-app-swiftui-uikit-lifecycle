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
    let communicator: ChatCommunicator
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

    init(for chat: ChatRepresentation, service: RemoteChatMessageFetcher, apiClient: ChatMessagesApiClient, auth: Auth, communicator: ChatCommunicator) {
        self.chat = chat
        self.service = service
        self.apiClient = apiClient
        self.auth = auth
        self.communicator = communicator
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
        
        communicator.receive(on: .send) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let message):
                    withAnimation {
                        self?.messages.insert(.init(id: message.id, sender: .init(id: message.sender.id, name: message.sender.name, image: nil, select: {_ in}), message: message.text, timestamp: Date(), image: nil), at: 0)
                    }
                    self?.image = nil
                    self?.scrollToEnd.send(message.id)
                    
                case .failure(_):
                    return
                }
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
                let id = chat.roomId else { return }
        communicator.send(message: .text(text.trimmed()), to: id) { [weak self] in
            print("SENT")
            self?.text = ""
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
