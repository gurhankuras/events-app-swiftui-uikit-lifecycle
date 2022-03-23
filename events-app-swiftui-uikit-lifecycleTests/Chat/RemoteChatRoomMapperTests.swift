//
//  RemoteChatRoomMapperTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 3/22/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle




class RemoteChatRoomMapperTests: XCTestCase {

    func test_map_roomImageDefaults_whenOtherUserHasNoProfileImage() {
        let me = RemoteChatRoomUser(id: "1", name: "gurhan", image: nil)
        let otherUser = RemoteChatRoomUser(id: "2", name: "gurhan", image: nil)
        let remoteChatRoom = RemoteChatRoom(id: "123",
                                            participants: [me, otherUser],
                                            lastMessage: nil)
        
        let mapper = RemoteChatRoomMapper(for: User(id: "1", email: "test@test.com"))
        let recentChat = mapper.map(room: remoteChatRoom)
    
        XCTAssertEqual(recentChat.imageUrl, mapper.defaults.image)
    }
    
    func test_map_shouldReturnCorrectFormat() {
        let me = RemoteChatRoomUser(id: "1", name: "gurhan", image: nil)
        let otherUser = RemoteChatRoomUser(id: "2", name: "gurhan", image: "Adam")
        let remoteChatRoom = RemoteChatRoom(id: "123",
                                            participants: [me, otherUser],
                                            lastMessage: nil)
        
        let mapper = RemoteChatRoomMapper(for: User(id: "1", email: "test@test.com"))
        
        let recentChat = mapper.map(room: remoteChatRoom)
    
        XCTAssertEqual(recentChat.imageUrl, otherUser.image)
        XCTAssertEqual(recentChat.id, remoteChatRoom.id)
        XCTAssertEqual(recentChat.name, otherUser.name)
    }
    
    func test_map_messageAndDateDefaults_whenThereIsNoLastMessage() {
        let me = RemoteChatRoomUser(id: "1", name: "gurhan", image: nil)
        let otherUser = RemoteChatRoomUser(id: "2", name: "gurhan", image: nil)
        let remoteChatRoom = RemoteChatRoom(id: "123",
                                            participants: [me, otherUser],
                                            lastMessage: nil)
        
        let mapper = RemoteChatRoomMapper(for: User(id: "1", email: "test@test.com"))
        
        let recentChat = mapper.map(room: remoteChatRoom)
        
        XCTAssertEqual(recentChat.message, mapper.defaults.text)
        XCTAssertEqual(recentChat.timestamp, nil)
    }
    
    func test_map_messageAndDateAssignedFromLastMessage_whenThereIsLastMessage() {
        let me = RemoteChatRoomUser(id: "1", name: "gurhan", image: nil)
        let otherUser = RemoteChatRoomUser(id: "2", name: "gurhan", image: nil)
        let lastMessageSentAt = Date()
        let lastMessage = RemoteChatRoomLastMessage(sentAt: lastMessageSentAt, sender: me, text: "Hello")
        let remoteChatRoom = RemoteChatRoom(id: "123",
                                            participants: [me, otherUser],
                                            lastMessage: lastMessage)
        
        let mapper = RemoteChatRoomMapper(for: User(id: "1", email: "test@test.com"))
        
        let recentChat = mapper.map(room: remoteChatRoom)
        
        XCTAssertEqual(recentChat.message, remoteChatRoom.lastMessage?.text)
        XCTAssertEqual(recentChat.timestamp, lastMessageSentAt)
    }

    func test_map_imageAndRoomNameDefaults_whenTheOnlyOneInTheRoomIsMe() {
        let me = RemoteChatRoomUser(id: "1", name: "gurhan", image: nil)
        let remoteChatRoom = RemoteChatRoom(id: "123",
                                            participants: [me],
                                            lastMessage: nil)
        
        let mapper = RemoteChatRoomMapper(for: User(id: "1", email: "test@test.com"))
        
        let recentChat = mapper.map(room: remoteChatRoom)

        XCTAssertEqual(recentChat.imageUrl, mapper.defaults.image)
        XCTAssertEqual(recentChat.name, mapper.defaults.name)
    }
}
