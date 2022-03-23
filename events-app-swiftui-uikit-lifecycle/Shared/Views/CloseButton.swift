//
//  CloseButton.swift
//  play
//
//  Created by Gürhan Kuraş on 3/9/22.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    let color: Color
    
    init(action: @escaping () -> Void, color: Color = .pink) {
        self.action = action
        self.color = color
    }
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(color)
                .font(.title3)
        }
    }
}

struct CloseButtonTest: View {
    @State var count = 0
   
    var body: some View {
        VStack {
            CloseButton(action: { count += 1 })
                .border(.pink, width: 1)
            Text("Clicked: \(count) times")
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CloseButton(action: {})
            CloseButton(action: {})
                .preferredColorScheme(.dark)
            CloseButtonTest()
        }
            .previewLayout(.sizeThatFits)
    }
}
