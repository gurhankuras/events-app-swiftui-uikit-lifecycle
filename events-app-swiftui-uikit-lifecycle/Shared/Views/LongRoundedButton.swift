//
//  LongRoundedButton.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct LongRoundedButton: View {
    let text: LocalizedStringKey
    @Binding var active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.pink)
                    .opacity(active ? 1 : 0.4)
            )
        }
        .disabled(!active)
    }
}

struct LongRoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        LongRoundedButton(text: "Sign in", active: .constant(true), action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
