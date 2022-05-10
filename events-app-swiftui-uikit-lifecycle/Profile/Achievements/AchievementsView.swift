//
//  TrophiesView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import SwiftUI

struct AchievementsView: View {
    @State var achievements: [Achievement] = [
        .init(title: "Yayıncı1", description: "İlk yayınını gerçekleştir", progress: .init(1, 2), image: ""),
        .init(title: "Yayıncı2", description: "İlk yayınını gerçekleştir", progress: .init(1, 1), image: ""),
        .init(title: "Yayıncı3", description: "İlk yayınını gerçekleştir", progress: .init(4, 9), image: ""),
        .init(title: "Yayıncı4", description: "İlk yayınını gerçekleştir", progress: .init(0, 500), image: ""),
        .init(title: "Yayıncı5", description: "İlk yayınını gerçekleştir", progress: .init(64, 100), image: "")
    ]
    var body: some View {
        VStack(alignment: .center) {
            Text("Achievements")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .padding()
            ForEach(achievements) { ach in
                AchievementCell(achivement: ach)
            }
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct TrophiesView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
