//
//  SigninView.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct SigninView: View {
    @ObservedObject var viewModel: SignupViewModel
    @Binding var next: Bool
    
    var body: some View {
        VStack {
            Spacer()
            SigningIllustration(named: "login_illust", action: openSignup)
            Text("Log in to your account")
                .signingTitle()
            SigningTextField(placeholder: "Email", text: $viewModel.email.value)
            SigningTextField(placeholder: "Password", text: $viewModel.password.value)
            LongRoundedButton(text: "Sign in", active: $viewModel.formValid) {
                viewModel.login()
                UIApplication.shared.endEditing()
            }
            SigningTransationText(text: "Don't have an account? ",
                                  link: "Sign up",
                                  action: openSignup)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .foregroundColor(.black)
    }
    
    func openSignup() {
        withAnimation(.spring()) {
            next.toggle()
        }
    }
}

/*
struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(viewModel:
                        .init(auth: Auth.shared, didSignIn: {}),
                   next: .constant(true))
    }
}
 */

struct SigningTransationText: View {
    let text: String
    let link: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Text(text)
            Text(link)
                .bold()
                .foregroundColor(.pink)
                .onTapGesture(perform: action)
        }
        .font(.system(size: 13))
    }
}
