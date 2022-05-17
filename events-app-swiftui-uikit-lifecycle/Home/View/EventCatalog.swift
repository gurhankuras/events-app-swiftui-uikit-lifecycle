//
//  EventsScrollView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI


struct EventCatalog<Cards: View>: View {
    let title: String
    @ViewBuilder let content: () -> Cards
    
    var body: some View {
        VStack {
            EventsViewHeader(title: title)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    content()
                }
            }
        }
    }
}

struct EventsViewHeader: View {
    let title: String

    var body: some View  {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextColor)
                .onTapGesture {
                    BannerService.shared.dismiss()
                }
            Spacer()
            
            Text("View All")
                .font(.caption)
                .foregroundColor(.appLightPurple)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
    }
}


/*
struct EventsShowcase_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            EventsShowcase(events: Event.fakes(repeat: 5), header: "Popular") {
                Text("Deneme")
            }
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
            
    }
}
*/
