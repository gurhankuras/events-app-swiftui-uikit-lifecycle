//
//  EventCardView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct EventCardView: View {
    let event: RemoteNearEvent
    let onClicked: (RemoteNearEvent) -> ()

    @State var isActive: Bool = false
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
        .onTapGesture(perform: { onClicked(event) })
    }
    
    private var image: some View {
        WebImage(url: URL(string: event.image))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: 150)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 15))
            .overlay(alignment: .bottom) {
                EventCardHeader(title: event.title)
            }
    }
    
    private var distanceIndicator: some View {
        Text("~\(Int(round(event.distance)))m")
            .font(.system(size: 12,
                          weight: .bold,
                          design: .rounded)
            )
            .padding(5)
            .foregroundColor(.white)
            .background(Color.black)
            .clipShape(Capsule())
    }
}


struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardView(event: RemoteNearEvent.stub, onClicked: {_ in})
            EventCardView(event: RemoteNearEvent.stub, onClicked: {_ in})
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
 

