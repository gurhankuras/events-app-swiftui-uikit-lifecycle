//
//  ChatCommunicatorTests.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 3/26/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle

protocol Communicator {
    func send(message: Message, to room: String, completion: @escaping () -> Void)
    func receive(on event: ServerChatEvent, callback: @escaping (Result<String, Error>) -> Void)
}

class FakeCommunicator: Communicator {
    struct DecodingError: Error {}
    private weak var socket: FakeSocket?
    init(socket: FakeSocket) {
        self.socket = socket
    }
    
    func send(message: Message, to room: String, completion: @escaping () -> Void) {
        socket?.add(event: ServerChatEvent.send.rawValue, message: message, completion: completion)
    }
    
    func receive(on event: ServerChatEvent, callback: @escaping (Result<String, Error>) -> Void) {
        socket?.addListener(for: event.rawValue) { [weak self] message in
            guard let msg = message as? Message,
        case let .text(txt) = msg
            else {
                callback(.failure(DecodingError()))
                return
            }
            
            callback(.success(txt))
        }
    }
}

class FakeSocket {
    private(set) var messages: [String: [Any]] = [:]
    private(set) var eventHandlers: [String: [(Any) -> Void]]
    
    init(messages: [String: [Any]] = [:], eventHandlers: [String: [(Any) -> Void]] = [:]) {
        self.messages = messages
        self.eventHandlers = eventHandlers
    }
    
    func add(event: String, message: Any, completion: @escaping () -> Void) {
        if var relatedEvents = messages[event] {
            relatedEvents.append(message)
            completion()
            return
        }
        messages[event] = []
        messages[event]?.append(message)
        completion()
        callListeners(for: event, message: message)
    }
    
    func addListener(for event: String, callback: @escaping (Any) -> Void) {
        guard var handlers = eventHandlers[event] else {
            eventHandlers[event] = []
            eventHandlers[event]?.append(callback)
            return
        }
        handlers.append(callback)
    }
    
    private func callListeners(for event: String, message: Any) {
        guard let handlers = eventHandlers[event] else {
            return
        }
        
        for handler in handlers {
            handler(message)
        }
    }
}

class ChatCommunicatorTests: XCTestCase {

    func test_calls_callback() {
        let socket = FakeSocket()
        let communicator = FakeCommunicator(socket: socket)
        //let expectation = expectation(description: #function)
        var girdi = false
        communicator.send(message: .text("gurhan"), to: "1") {
            girdi = true
        }
        XCTAssertTrue(girdi)
    }
    
    func testif() {
        let socket = FakeSocket()
        let communicator = FakeCommunicator(socket: socket)
        let anotherCommunicator = FakeCommunicator(socket: socket)
        var message: String?

        anotherCommunicator.receive(on: .send) { m in
            guard case let .success(text) = m else { return }
            message = text
        }
        communicator.send(message: .text("gurhan"), to: "1") { }
        XCTAssertNotNil(message)
    }

}
