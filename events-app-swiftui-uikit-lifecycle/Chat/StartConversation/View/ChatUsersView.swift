//
//  ChatUsersView.swift
//  play
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI
import Combine

struct ChatUsersView: View {
    @StateObject var viewModel: ChatUsersViewModel
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ChatUsersToolbar(dismiss: dismiss)
            SearchBar(placeholder: "Search User", text: $viewModel.query)
            ChatUsersList(
                users: viewModel.users
            )
        }
        
    }
}





/*
struct ChatUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatUsersView()
    }
}
*/

fileprivate struct ChatUsersToolbar: View {
    let dismiss: () -> Void

    var body: some View {
        HStack {
            CloseButton(action: dismiss,
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
