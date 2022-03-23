//
//  ContentView.swift
//  websocket-demo
//
//  Created by Gürhan Kuraş on 3/3/22.
//

import SwiftUI

struct RecentChatsView: View {
    @StateObject var viewModel = ChatRoomsViewModel()
    @EnvironmentObject var root: ChatRoot
    
   
    
    var body: some View {
        let _ = print("RecentChatsView body")
        NavigationView {
            VStack {
                ChatRoomList(rooms: viewModel.rooms,
                             onChatDeleted: deleteChatHandler,
                             onChatTapped: selectChatHandler)
            }

            .background(
                chatLogsLink
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingNewChatSelection.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Chat")
                        .fontWeight(.medium)
                }
            }
            .sheet(isPresented: $viewModel.showingNewChatSelection) {
                ChatUsersView()
                    .environmentObject(root)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .actionSheet(isPresented: $viewModel.showingOptions) {
            actionSheet
        }
    }
    
    private func deleteChatHandler() {
        viewModel.showingOptions.toggle()
    }
    
    private func selectChatHandler(chat: RecentChat) {

        root.tappedChat(for: chat)
    }
    
    private var chatLogsLink: some View {
        NavigationLink(isActive: $root.showChatMessages, destination: {
            LazyView {
                root.chatLogs()
                //ChatLogsView(roomId: $roomId)
            }
        }, label: {
            EmptyView()
        })
         
    }
    
    
    private var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Are you sure?"),
            buttons: [
                .destructive(Text("Delete")) {

                },
            ]
        )
    }
}

struct RecentChatsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentChatsView()
    }
}

struct ChatRoomList: View {
    let rooms: [RecentChat]
    let onChatDeleted: () -> Void
    let onChatTapped: (RecentChat) -> Void
    var body: some View {
        List {
            ForEach(rooms) { chat in
                Button {
                    onChatTapped(chat)
                } label: {
                    ChatRoomCell(chat: chat)
                }
                .accentColor(.primary)
                 
            }
            .onDelete { indexSet in
                onChatDeleted()
            }
            .listRowInsets(.init())
        }
        .listStyle(.plain)
    }
}

