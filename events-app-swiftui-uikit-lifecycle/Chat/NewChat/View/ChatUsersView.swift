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
            SearchBar(placeholder: "search", text: $viewModel.query)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .background(Color(.systemBackground))
            ChatUsersList(
                users: viewModel.users
            )
        }
        .background(Color("backgroundColor"))

        
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
                        color: .appTextColor)
            Spacer()
            Text("new-chat-title")
                .font(.system(size: 15).bold())
                .foregroundColor(.appTextColor)
            Spacer()
            CloseButton(action: {})
                .foregroundColor(.background)
                .hidden()
        }
        .padding()
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
    }
}
