//
//  ChatAccessContainerView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/24/22.
//

import SwiftUI

class ChatAccessContainerViewModel: ObservableObject {
    let authService: AuthService
    
    @Published var isAuthenticated: Bool = false
    
    init(authService: AuthService) {
        self.authService = authService
        self.authService.userPublisher
            .map({ (status) -> Bool in
                if case .loggedIn(_) = status {
                    return true
                }
                return false
            })
            .removeDuplicates()
            .assign(to: &$isAuthenticated)
    }
}

struct ChatAccessContainerView<AuthContent: View, NonAuthContent: View>: View {
    @StateObject var viewModel: ChatAccessContainerViewModel
    @ViewBuilder var authenticated: () -> AuthContent
    @ViewBuilder var unauthenticated: () -> NonAuthContent
    var body: some View {
        if viewModel.isAuthenticated {
            authenticated()
        }
        else {
            unauthenticated()
        }
    }
}

/*
struct ChatAccessContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAccessContainerView(
            auth: .
            authenticated: {EmptyView()},
            unauthenticated: {EmptyView()}
        )
    }
}
*/
