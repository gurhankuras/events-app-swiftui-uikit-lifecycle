//
//  SigningTextField.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct SigningTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(!text.isEmpty ? .pink : .gray.opacity(0.85), lineWidth: 2)
            )
            .foregroundColor(.appTextColor)
            .padding(.vertical, 5)
    }
}


struct SigningTextField_Previews: PreviewProvider {
    static let text: String = "gurhankuras@hotmail.com"
    static var previews: some View {
        Group {
            SigningTextField(placeholder: "Email", text: .constant(text))
            SigningTextField(placeholder: "Email", text: .constant(""))
            
            Group {
                SigningTextField(placeholder: "Email", text: .constant(text))
                SigningTextField(placeholder: "Email", text: .constant(""))
            }
            .preferredColorScheme(.dark)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
