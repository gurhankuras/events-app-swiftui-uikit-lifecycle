//
//  CoreDataChatMessageRepository.swift
//  play
//
//  Created by Gürhan Kuraş on 3/5/22.
//

import Foundation
import CoreData
import Combine

/*
class CoreDataChatMessageRepository {
    private let container: NSPersistentContainer
    private let containerName: String = "ChatContainer"
    private let entityName: String = "ChatMessageEntity"
    private let logger = AppLogger(type: CoreDataChatMessageRepository.self)
    deinit {
        logger.e(#function)
    }
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
    }
    
    func get() -> AnyPublisher<[ChatMessage], Error> {
        let request = NSFetchRequest<ChatMessageEntity>(entityName: entityName)
        do {
            let entities = try container.viewContext.fetch(request)
            let processedMessages = entities
                                    .compactMap({ makeChatMessage(entity: $0) })
            
            return Just(processedMessages)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch let error {
            print("Error fetching ChatMessage entities \(error)")
            return Fail(outputType: [ChatMessage].self, failure: error)
                .eraseToAnyPublisher()
        }
    }
    
    func add(message: ChatMessage) -> Bool {
        let entity = ChatMessageEntity(context: container.viewContext)
        entity.id = message.id
        entity.message = message.message
        entity.sender = message.sender
        entity.sentAt = message.timestamp
        return save()
    }
    
    private func makeChatMessage(entity: ChatMessageEntity) -> ChatMessage? {
        guard let sender = entity.sender,
              let timestamp = entity.sentAt,
              let message = entity.message else { return nil }
        return ChatMessage(id: UUID().uuidString, sender: sender, message: message, timestamp: timestamp)
    }
    
    private func save() -> Bool {
        do {
            try container.viewContext.save()
            return true
        } catch let error {
            print("Error saving to Core Data \(error)")
            return false
        }
    }
    
    func clear() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
        } catch let error as NSError {
            print("Error while deleting all chat messages: \(error)")
            // TODO: handle the error
        }
    }
}
*/
