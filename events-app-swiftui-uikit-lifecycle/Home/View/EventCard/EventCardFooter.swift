//
//  EventCardFooter.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import SwiftUI

struct EventCardFooter: View {
    let event: EventCatalogCardViewModel
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "location")
                        .foregroundColor(Color(UIColor.systemPink))
                Text(event.address)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color(UIColor.systemPink))
                    Text(event.startsAt)
                        .font(.caption)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
}

struct EventCardFooter_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventCardFooter(event: EventCatalogCardViewModel(.stub))
            EventCardFooter(event: EventCatalogCardViewModel(.stub))
                .preferredColorScheme(.dark)
        }
            .previewLayout(.sizeThatFits)
    }
}
