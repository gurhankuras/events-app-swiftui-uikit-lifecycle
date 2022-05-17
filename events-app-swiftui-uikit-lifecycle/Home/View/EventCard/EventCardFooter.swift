//
//  EventCardFooter.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import SwiftUI

struct EventCardFooter: View {
    let event: RemoteNearEvent
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "location")
                        .foregroundColor(.pink)
                    Text("\(event.address.district) / \(event.address.city)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(.pink)
                    Text("25 March 2022\n06.00 PM")
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
            EventCardFooter(event: RemoteNearEvent.stub)
            EventCardFooter(event: RemoteNearEvent.stub)
                .preferredColorScheme(.dark)
        }
            .previewLayout(.sizeThatFits)
    }
}
