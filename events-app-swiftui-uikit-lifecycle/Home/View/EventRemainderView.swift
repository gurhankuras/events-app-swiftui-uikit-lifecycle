//
//  EventRemainderView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/10/22.
//

import SwiftUI

struct EventRemainderView: View {
    
    private let eventCount: UInt
    let load: () -> Void
    init(count: UInt, load: @escaping () -> Void) {
        self.eventCount = count
        self.load = load
    }
  
    var body: some View {
        HStack {
            Text("event-remainder \(0)")
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
        
       load()
    }
    
}

struct EventRemainderView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([
            ColorScheme.light,
            ColorScheme.dark
        ], id: \.self) { scheme in
            EventRemainderView(count: 5, load: {})
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
    }
}


 
