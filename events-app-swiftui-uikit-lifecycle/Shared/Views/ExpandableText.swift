//
//  ExpandableText.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import SwiftUI

struct ExpandableText: View {
    @Environment(\.lineLimit) var lineLimit
    
    private let text: String
    @State private var expanded: Bool
    
    init(text: String, initial: ExpansionState) {
        self.text = text
        _expanded = State(initialValue: initial == .open ? true : false)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.system(size: 15))
                .lineLimit(expanded ? nil : lineLimit)
            
            Image(systemName: "chevron.down")
                .rotationEffect(.degrees(expanded ? 180 : 0))
                .padding(.vertical, 10)
            
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        expanded.toggle()
                    }
                }
        }
        .padding()
    }
    
    
}


extension ExpandableText {
    enum ExpansionState {
        case open
        case closed
    }
}

struct ExpandableText_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableText(text: longText, initial: .open)
    }
}




