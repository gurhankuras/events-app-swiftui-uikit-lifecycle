//
//  EventCardHeader.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import SwiftUI

struct EventCardHeader: View {
    let title: String
    @State private var isFavorite = false
    
    let gradient = LinearGradient(colors: [.black.opacity(0.7), .black.opacity(0.4)], startPoint: .bottom, endPoint: .top)
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13,
                              weight: .regular,
                              design: .rounded)
                )
                .lineLimit(2)
            Spacer()
            favoriteButton
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gradient)
    }
    
    private var favoriteButton: some View {
        Image(systemName: isFavorite ? "star.fill" : "star")
            .imageScale(.medium)
            .foregroundColor(isFavorite ? .yellow : .white)
            .padding(4)
            .onTapGesture {
                isFavorite.toggle()
            }
    }
}


struct EventCardHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardHeader(title: "Merhaba")
            EventCardHeader(title: "Merhaba")
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
