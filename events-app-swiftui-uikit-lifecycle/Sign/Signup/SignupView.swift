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
        .foregroundColor(Color.black.opacity(0.7))
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
            Text("Sign up and explore events ahead")
                .signingTitle()
                
            SigningTextField(placeholder: "Email", text: $viewModel.email.value)
            SigningTextField(placeholder: "Password", text: $viewModel.password.value)
            LongRoundedButton(text: "Sign up",
                              active: $viewModel.formValid,
                              action: handleSignup)
            SigningTransationText(text: "Already have an account? ",
                                  link: "Sign in",
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewModel: .init(auth: Auth.shared, didSignIn: {}), next: .constant(true))
    }
}
