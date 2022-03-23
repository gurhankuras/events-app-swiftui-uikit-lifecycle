//
//  ChatUsersView.swift
//  play
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI
import Combine

struct ChatUsersView: View {
    @StateObject var viewModel = ChatUsersViewModel(fetcher: RemoteChatUsersAdapter(fetcher: RemoteChatUsersFetcher(network: JsonGetAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))  )))
    @Environment(\.presentationMode) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ChatUsersToolbar()
            SearchBar(placeholder: "Search User", text: $viewModel.query)
            ChatUsersList(
                users: viewModel.users,
                onDismiss: { dismiss.wrappedValue.dismiss() }
            )
        }
        
    }
}





struct ChatUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatUsersView()
    }
}

fileprivate struct ChatUsersToolbar: View {
    @Environment(\.presentationMode) var dismiss

    var body: some View {
        HStack {
            CloseButton(action: { dismiss.wrappedValue.dismiss() },
                        color: Color.white)
            Spacer()
            Text("New Chat")
                .font(.system(size: 15).bold())
                .foregroundColor(Color.white)
            Spacer()
            CloseButton(action: {})
                .hidden()
                .foregroundColor(Color.white)
        }
        .padding()
        .background(Color.appPurple.ignoresSafeArea())
    }
}
