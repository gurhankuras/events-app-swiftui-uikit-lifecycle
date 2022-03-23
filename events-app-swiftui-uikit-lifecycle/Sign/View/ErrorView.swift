//
//  ErrorView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/28/22.
//

import SwiftUI

struct ErrorView: View {
    @Binding var error: String
    let color = Color.black.opacity(0.7)
    let onCancel: () -> Void
    
    var body: some View {
        GeometryReader { _ in
            _ErrorView(error: $error, color: color, onCancel: onCancel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: onCancel)
        )
            
    }
}

struct ErrorView_Previews: PreviewProvider {
    static let error = Binding.constant("Hello nasilsin Hello nas")
    static var previews: some View {
        ErrorView(error: error, onCancel: {})
    }
}

fileprivate struct _ErrorView: View {
    @Binding var error: String
    let color: Color
    let onCancel: () -> Void

    var body: some View {
    
            VStack {
                HStack {
                    Text("Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(error)
                    .foregroundColor(color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button {
                    onCancel()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120
                        )
                }
                .background(Color.pink)
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            
    }
    
}
