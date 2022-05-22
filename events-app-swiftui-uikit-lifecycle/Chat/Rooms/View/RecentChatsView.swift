//
//  ContentView.swift
//  websocket-demo
//
//  Created by Gürhan Kuraş on 3/3/22.
//

import SwiftUI

struct RoomsView: View {
    @StateObject var viewModel: ChatRoomsViewModel
    let onStartNewChat: () -> Void
    
    var body: some View {
        let _ = print("RoomsView body")
        VStack(spacing: 0) {
            RoomsToolbar {
                onStartNewChat()
            }
            ChatRoomList(rooms: viewModel.rooms,
                         onChatDeleted: deleteChatHandler)
        }
        .navigationBarHidden(true)
    }
    
    private func deleteChatHandler() {
        viewModel.showingOptions.toggle()
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

/*
struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(viewModel: .init(), onStartNewChat: {})
    }
}
 */

struct ChatRoomList: View {
    let rooms: [RoomViewModel]
    let onChatDeleted: () -> Void
    var body: some View {
        List {
            ForEach(rooms) { chat in
                Button {
                    chat.select?(chat)
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


struct RoomsToolbar: View {
    let onStartConversation: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "plus")
                .font(.body)
                .hidden()
            Spacer()
            Text("Chat")
                .fontWeight(.medium)
            Spacer()
            Button {
                onStartConversation()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20))
            }
        }
        .padding()
    }
}
