//
//  RedirectToSignView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/24/22.
//

import SwiftUI

struct RedirectToSignView: View {
    let onClickedSignIn: () -> ()
    
    var body: some View {
        ZStack {
            Color.background
            VStack {
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 50))
                    .padding(.bottom)
                Text("not-signed-in-info-text")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                Button {
                    onClickedSignIn()
                } label: {
                    Text("sign-in-text")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        
                }
                .tint(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(Color.pink)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
            }
        }
    }
        
}

struct RedirectToSignView_Previews: PreviewProvider {
    static var previews: some View {
        RedirectToSignView(onClickedSignIn:  {})
    }
}
