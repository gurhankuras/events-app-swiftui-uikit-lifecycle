//
//  SignupView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import SwiftUI

struct SignView: View {
    @StateObject var viewModel: SignupViewModel
    let dismiss: () -> Void
    @State private var next: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                if !next {
                    SigninView(viewModel: viewModel, next: $next)
                        .transition(.move(edge: .leading))
                }
                if next {
                    SignupView(viewModel: viewModel, next: $next)
                        .transition(.move(edge: .trailing))
                }
            }
            if !viewModel.error.isEmpty {
                ErrorView(error: $viewModel.error, onCancel: viewModel.dismissError)
            }
        }
        
        .overlay(
            CloseButton(action: dismiss)
                .padding(),
            alignment: .topLeading
        )
        .onAppear {
            viewModel.start()
        }
         
    }
}

/*
struct SignViewView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
    }
    
}
*/
