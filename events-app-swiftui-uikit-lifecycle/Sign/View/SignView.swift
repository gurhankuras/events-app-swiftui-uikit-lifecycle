//
//  SignupView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import SwiftUI

struct SignView: View {
    @Binding var isPresented: Bool
    @State private var next: Bool = false
    @StateObject private var viewModel: SignupViewModel
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        let vm = SignupViewModel(auth: Auth.shared, didSignIn: {
            isPresented.wrappedValue = false
        })
        self._viewModel = StateObject(wrappedValue: vm)
    }

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
            CloseButton(action: { isPresented.toggle() })
                .padding(),
            alignment: .topLeading
        )
        .onAppear {
            viewModel.start()
        }
         
    }
}

struct SignViewView_Previews: PreviewProvider {
    static var previews: some View {
        SignView(isPresented: .constant(true))
    }
    
}
