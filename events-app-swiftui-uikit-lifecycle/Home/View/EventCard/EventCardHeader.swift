//
//  EventCardHeader.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import SwiftUI

struct EventCardHeader: View {
    init(event: EventCatalogCardViewModel) {
        self._event = State(initialValue: event)
    }
    
    @State var event: EventCatalogCardViewModel
    
    let gradient = LinearGradient(colors: [.black.opacity(0.7), .black.opacity(0.4)], startPoint: .bottom, endPoint: .top)
    
    var body: some View {
        HStack {
            Text(event.title)
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
        Image(systemName: event.isFavorite ? "star.fill" : "star")
            .imageScale(.medium)
            .foregroundColor(event.isFavorite ? .yellow : .white)
            .padding(4)
            .onTapGesture {
                event.isFavorite.toggle()
            }
    }
}


struct EventCardHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardHeader(event: .init(.stub))
            EventCardHeader(event: .init(.stub))
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
