//
//  SigningIllustration.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct SigningIllustration: View {
    let named: String
    let action: () -> Void
    var body: some View {
        Image("login_illust")
            .resizable()
            .scaledToFit()
            .frame(width: 250)
            .onTapGesture(perform: action)
    }
}

struct SigningIllustration_Previews: PreviewProvider {
    static var previews: some View {
        SigningIllustration(named: "login_illust", action: {})
    }
}
