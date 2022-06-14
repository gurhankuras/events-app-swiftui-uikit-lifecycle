//
//  RegularAppBar.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import SwiftUI

struct RegularAppBar: View {
    let title: LocalizedStringKey
    let back: () -> ()
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                backButton
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity)
                backButton.hidden().disabled(true)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            Divider().ignoresSafeArea()
        }
        .padding(.top)
        
    }
    
    private var backButton: some View {
        Image(systemName: "arrow.backward")
            .foregroundColor(.appTextColor)
            .padding(.all, 5)
            .onTapGesture {
                back()
            }
    }
}

struct RegularAppBar_Previews: PreviewProvider {
    static var previews: some View {
        RegularAppBar(title: "Address", back: {})
            .previewLayout(.sizeThatFits)
    }
}
