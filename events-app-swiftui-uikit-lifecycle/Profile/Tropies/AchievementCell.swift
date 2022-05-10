//
//  AchievementCell.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import SwiftUI

struct AchievementCell: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 85, height: 100)
            VStack(alignment: .leading) {
                Text("Title")
                Text("Description")
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
            }
            .padding(.horizontal, 8)
        }
    }
}

struct AchievementCell_Previews: PreviewProvider {
    static var previews: some View {
        AchievementCell()
    }
}
