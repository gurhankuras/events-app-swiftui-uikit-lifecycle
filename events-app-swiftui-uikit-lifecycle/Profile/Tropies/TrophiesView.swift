//
//  TrophiesView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import SwiftUI

struct TrophiesView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Achievements")
            ForEach(0...5, id: \.self) { index in
                AchievementCell()
                    .padding(.horizontal, 10)
            }
        }
        .navigationBarHidden(true)
    }
}

struct TrophiesView_Previews: PreviewProvider {
    static var previews: some View {
        TrophiesView()
    }
}
