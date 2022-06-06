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
    let auth: AuthService
    let communicator: ChatCommunicator
    let room: Room
    let scroller = ChatScroller()
    
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
    
   

    init(for room: Room, service: RemoteChatMessageFetcher, auth: AuthService, communicator: ChatCommunicator) {
        logger.i(#function)
        
        self.room = room
        self.service = service
        self.auth = auth
        self.communicator = communicator
              
        authCancellable = auth.userPublisher.sink(receiveValue: { [weak self] status in self?.onAuthChange(status: status) })
        communicator.receive(on: .send) { [weak self] result in self?.onReceiveMessage(result: result) }
    }
    
    func onAuthChange(status: AuthStatus) {
        switch status {
        case .loggedIn(let user):
            self.currentUser = user
            break
        default:
            self.currentUser = nil
        }
    }
    
    func onReceiveMessage(result: Result<RemoteChatBucketMessage, Error>) {
        print("RECEIVE")
        DispatchQueue.main.async {
            switch result {
            case .success(let message):
                withAnimation {
                    self.messages.insert(.init(id: message.id, sender: .init(id: message.sender.id, name: message.sender.name, image: nil, select: {_ in}), message: message.text, timestamp: Date(), image: nil), at: 0)
                }
                self.image = nil
                self.scroller.scrollTo(positionOf: message.id)
                
            case .failure(_):
                return
            }
        }
    }
    
    
    func userOwnsMessage(_ message: ChatMessage) -> Bool {
        guard let user = currentUser else { return false }
        return message.belongs(to: user)
    }
     
    
    var canSendMessage: Bool {
        return !text.trimmed().isEmpty || image != nil
    }

    
    func send() {
        guard currentUser != nil else { return }
        communicator.send(message: .text(text.trimmed()), to: room.id) { [weak self] in
            print("SENT")
            self?.text = ""
        }
    }
    
    deinit {
        logger.e(#function)
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
        guard  !isLoading && canLoadMore else {
            print("page: \(page), isLoading: \(isLoading), canLoadMore: \(canLoadMore)")
            return
        }
        
        isLoading = true
        cancellable = service.fetch(for: room.id, at: page)
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
