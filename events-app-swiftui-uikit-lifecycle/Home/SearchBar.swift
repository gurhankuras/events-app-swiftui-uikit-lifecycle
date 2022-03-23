//
//  SearchBar.swift
//  play
//
//  Created by Gürhan Kuraş on 2/11/22.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: String
    @Binding var text: String
    
    //@FocusState var focused: Bool
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray))
            TextField(placeholder, text: $text)
                .padding(.trailing, 30)
                .overlay(
                   
                           Image(systemName: "xmark.circle.fill")
                               .foregroundColor(Color(.systemGray))
                               .padding(5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                               .onTapGesture {
                                   if text.isEmpty {
                                       print("sadasd")
                                       //focused.toggle()
                                   }
                                   else {
                                       text = ""
                                       UIApplication.shared.endEditing();
                                   }
                                   
                               }
                                
                               .opacity(text.isEmpty ? 0 : 1)
                    ,
                    alignment: .trailing
                )
                //.focused($focused)
                .disableAutocorrection(true)
                
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.card)
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static let text = Binding.constant("dsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsdsfdsfdsf")
    
    static var previews: some View {
        Group {
            VStack {
                SearchBar(placeholder: "Find Events", text: text)
            }
            .padding()
            .background(Color.appPurple)
                
            SearchBar(placeholder: "Find Events", text: text)
                .preferredColorScheme(.dark)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}




