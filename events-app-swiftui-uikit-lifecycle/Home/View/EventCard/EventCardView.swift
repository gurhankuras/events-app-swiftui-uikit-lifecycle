//
//  EventCardView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventCardView: View {
    let event: EventCatalogCardViewModel
    let width = UIScreen.main.bounds.width * 0.65
    
    var body: some View {
        VStack {
            image
            EventCardFooter(event: event)
        }
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.card)
        )
        .overlay(alignment: .topTrailing) {
            distanceIndicator
        }
        .onTapGesture(perform: event.select)
    }
    
    private var image: some View {
        WebImage(url: URL(string: event.image))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: 150)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 15))
            .overlay(alignment: .bottom) {
                EventCardHeader(event: event)
            }
    }
    
    private var distanceIndicator: some View {
        Text(event.distance)
            .font(.system(size: 12,
                          weight: .bold,
                          design: .rounded)
            )
            .padding(5)
            .foregroundColor(.white)
            .background(Color.appPurple)
            .clipShape(Capsule())
    }
}


struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardView(event: .init(.stub))
            EventCardView(event: .init(.stub))
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
 

