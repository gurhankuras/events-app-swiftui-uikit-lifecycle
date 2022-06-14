//
//  HomeEventsView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct EventCategoriesView: View {
    let categories: [String]
    let onTappedCategory: (EventCategoryType) -> ()
    
    init(_ categories: [String], onTappedCategory: @escaping (EventCategoryType) -> ()) {
        self.categories = categories
        self.onTappedCategory = onTappedCategory
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                        EventTypeChip(type: category)
                        .onTapGesture {
                            guard let categoryType = EventCategoryType.init(rawValue: category.lowercased()) else {
                                fatalError("Category value not found in enum!")
                            }
                            onTappedCategory(categoryType)
                        }
                }
            }
            .padding(.leading)
        }
    }
}

struct EventTypeChip: View {
    let type: String
    var backgroundColor: Color = Color(UIColor.systemPink)

    var body: some View {
        Text(type)
            .font(.custom("deneme", size: 15, relativeTo: .body))
            .foregroundColor(.white)
            .padding(8)
            .background(backgroundColor)
            .clipShape(Capsule(style: .continuous))
    }
}

extension EventTypeChip {
    func backgroundColor(_ color: Color) -> Self {
        var view = self
        view.backgroundColor = color
        return view
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
