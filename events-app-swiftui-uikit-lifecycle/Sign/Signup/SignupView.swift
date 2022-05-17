//
//  SignupView.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI


struct SigningTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(Font.title2.bold())
        .foregroundColor(Color.appTextColor.opacity(0.7))
    }
}


 

extension View {
    func signingTitle() -> some View {
        modifier(SigningTitleModifier())
    }
}

struct SignupView: View {
    @ObservedObject var viewModel: SignupViewModel
    @Binding var next: Bool

    var body: some View {
        VStack {
            Spacer()
            SigningIllustration(named: "login_illust", action: openSignin)
            Text("sign-up-header")
                .signingTitle()
                
            SigningTextField(placeholder: "email-field-placeholder", text: $viewModel.email.value)
            SigningTextField(placeholder: "password-field-placeholder", text: $viewModel.password.value)
            
            LongRoundedButton(text: "sign-up-button",
                              active: $viewModel.formValid,
                              action: handleSignup)
            SigningTransationText(text: "already-have-account",
                                  link: "already-have-account-sign-in",
                                  action: openSignin)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .foregroundColor(.black)
    }
    
    func openSignin() {
        withAnimation(.spring()) {
            next.toggle()
        }
    }
    
    func handleSignup() {
        viewModel.signUp()
        UIApplication.shared.endEditing()
    }
}

/*
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewModel: .init(auth: Auth.shared, didSignIn: {}), next: .constant(true))
    }
}
*/
