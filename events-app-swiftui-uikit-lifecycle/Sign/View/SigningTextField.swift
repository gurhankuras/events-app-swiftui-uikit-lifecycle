//
//  SigningTextField.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct SigningTextField: View {
    var keyboardType: UIKeyboardType = .default
    var font: Font = .system(size: 14)
    
    let placeholder: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .autocapitalization(.none)
            .keyboardType(keyboardType)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(!text.isEmpty ? .pink : Color.gray, lineWidth: 1)
            )
            .font(font)
            .foregroundColor(Color.black)
            //.foregroundColor(.appTextColor)
            .padding(.vertical, 5)
    }
}

extension SigningTextField {
    func keyboardType(_ type: UIKeyboardType) -> some View {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func font(_ font: Font) -> some View {
        var view = self
        view.font = font
        return view
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
