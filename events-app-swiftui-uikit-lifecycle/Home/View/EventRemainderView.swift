//
//  EventRemainderView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct EventRemainderView: View {
    
    private let eventCount: UInt

    init(count: UInt) {
        self.eventCount = count
    }
  
    var body: some View {
        HStack {
            Text("You have 0 events this week")
                .font(.custom("", size: 15, relativeTo: .body))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Button(action: checkStatus, label: {
                
                Text("Check Status")
                    .font(.custom("", size: 15, relativeTo: .body))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.pink)
                    .clipShape(Capsule())
            })
            
        }
        .padding()
        .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.card)
                    .shadow(radius: 1)
        )
    }
    
    func checkStatus() {
       
    }
    
}

struct EventRemainderView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            EventRemainderView(count: 5)
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}


 