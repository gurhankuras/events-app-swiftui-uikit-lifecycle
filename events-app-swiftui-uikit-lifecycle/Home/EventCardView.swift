//
//  EventCardView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct EventCardView: View {
    @State var isActive: Bool = false
    let event: Event

    var body: some View {
        VStack {
            Image(event.image)
                .resizable()
                .aspectRatio(5/3, contentMode: .fit)
                .clipShape(CustomShape(corner: [.topRight, .topLeft], radii: 15))
                .overlay(EventImageOverlay(title: event.title), alignment: .bottomLeading)
            
            EventAdditionalInfo(event: event)
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.card)
        )
        .onTapGesture {
            isActive.toggle()
                
            print("clicked")
        }
        .background(
            NavigationLink(isActive: $isActive, destination: {
                EventDetails()
            }, label: {
                EmptyView()
            })
        )
        
    }
}


struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardView(event: Event.fake)
            EventCardView(event: Event.fake)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .padding()
        
    }
}

struct EventImageOverlay: View {
    let title: String
    @State private var isFavorite = false
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: isFavorite ? "star.fill" : "star")
                .imageScale(.medium)
                .foregroundColor(isFavorite ? .yellow : .white)
                .padding(4)
                .onTapGesture {
                    isFavorite.toggle()
                }
        }
        .foregroundColor(.white)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.black.opacity(0.7), .black.opacity(0.4)], startPoint: .bottom, endPoint: .top))
        
    }
}

struct EventAdditionalInfo: View {
    let event: Event
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "location")
                    .foregroundColor(.pink)
                Text("Hilton San Fransisco Gel Bakalim dasdsad  sadasdasdas sadasdas")
                    .font(.caption)
                    .fontWeight(.medium)
                //.frame(maxWidth: .infinity)
                    .lineLimit(2)
            }
            Spacer()
            
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(.pink)
                Text(event.address)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                //.frame(maxWidth: .infinity)
                
                
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
