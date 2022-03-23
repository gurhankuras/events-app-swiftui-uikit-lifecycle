//
//  HomeEventsView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI



struct HomeContentView: View {
    let categories: [String] = ["All", "Business", "Culture", "Music", "Conference"]
    let eventStubs: [Event] = Event.fakes(repeat: 5)
    
    var body: some View {
        ScrollView {
            VStack {
                EventCategoriesView(categories)
                    .padding(.bottom, 25)
                    //.padding([.leading, .bottom], 25)
                EventsShowcase(events: eventStubs, header: "Popular") {
                    Text("Events")
                }.padding(.bottom)
                
                EventsShowcase(events: eventStubs, header: "Popular") {
                    Text("Events")
                }.padding(.bottom)
                
                EventsShowcase(events: eventStubs, header: "Popular") {
                    Text("Events")
                }.padding(.bottom)
                
                EventsShowcase(events: eventStubs, header: "Popular") {
                    Text("Events")
                }
            }
            //.padding(.horizontal, 10)
            
        }
        
    }
}

struct EventCategoriesView: View {
    let categories: [String]
    
    init(_ categories: [String]) {
        self.categories = categories
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.custom("deneme", size: 15, relativeTo: .body))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.pink)
                        .clipShape(Capsule(style: .continuous))
                }
            }
            .padding(.leading)
        }
    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            HomeContentView()
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}

