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
            Text("sign-in-header")
                .signingTitle()
            SigningTextField(placeholder: "email-field-placeholder", text: $viewModel.email.value)
            SigningTextField(placeholder: "password-field-placeholder", text: $viewModel.password.value, masked: true)
            LongRoundedButton(text: "sign-in-button", active: $viewModel.signInformValid) {
                viewModel.login()
                UIApplication.shared.endEditing()
            }
            SigningTransationText(text: "dont-have-account",
                                  link: "dont-have-account-sign-up",
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
    let text: LocalizedStringKey
    let link: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Text(text)
                .foregroundColor(.appTextColor)
            Text(link)
                .bold()
                .foregroundColor(.pink)
                .onTapGesture(perform: action)
        }
        .font(.system(size: 13))
    }
}
