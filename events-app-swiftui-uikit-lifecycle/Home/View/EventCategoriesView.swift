//
//  HomeEventsView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

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
                        .onTapGesture {
                            if (category == "All") {
                                BannerService.shared.show(icon: .failure, title: "Failed...", action: .custom("DISOBEY", { print("Kapatmayacagim!") }) )
                            }
                            else {
                                BannerService.shared.show(icon: .success, title: "Success...", action: .close)
                            }
                            
                        }
                }
            }
            .padding(.leading)
        }
    }
}

/*
struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            HomeContentView(eventStubs: Event.fakes(repeat: 5))
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}


*/
