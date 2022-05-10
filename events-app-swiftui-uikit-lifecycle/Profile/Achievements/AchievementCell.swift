//
//  AchievementCell.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/10/22.
//

import SwiftUI


struct Progress {
    let completed: Int
    let total: Int
    
    init(_ completed: Int, _ total: Int) {
        self.completed = completed
        self.total = total
    }
    
    var percent: CGFloat {
        return CGFloat(completed) / CGFloat(total)
    }
}
struct Achievement: Identifiable {
    let title: String
    let description: String
    let progress: Progress
    let image: String
    
    var completed: Bool {
        return progress.total == progress.completed
    }
    
    var id: String {
        return title
    }    
    
}

struct AchievementCell: View {
    let achivement: Achievement
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(.orange)
                .frame(width: 85, height: 100)
            VStack(alignment: .leading, spacing: 9) {
                Text(achivement.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Text(achivement.description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .lineLimit(2)
                    
                HStack {
                    LinearProgressView(progress: achivement.progress, primaryColor: .orange, secondaryColor: .secondary)
                    Text("\(achivement.progress.completed)/\(achivement.progress.total)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 10)
        .opacity(achivement.completed ? 0.3 : 1)
    }
}

struct AchievementCell_Previews: PreviewProvider {
    static var previews: some View {
        AchievementCell(achivement: .init(title: "Yayıncı", description: "İlk yayınını gerçekleştir", progress: .init(2, 2), image: ""))
            .previewLayout(.sizeThatFits)
    }
}

struct LinearProgressView: View {
    let progress: Progress
    let activeColor: Color
    let passiveColor: Color
    
    init(progress: Progress,
         primaryColor: Color = Color.appPurple,
         secondaryColor: Color = Color.secondary) {
        self.progress = progress
        self.activeColor = primaryColor
        self.passiveColor = secondaryColor
    }
    
    var body: some View {
        Rectangle()
            .fill(passiveColor)
            .frame(maxWidth: .infinity)
            .frame(height: 16)
            .cornerRadius(5)
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    Rectangle()
                        .fill(activeColor)
                        .frame(maxWidth: geo.size.width * progress.percent)
                        .frame(height: 16)
                        .cornerRadius(5)
                }
            }
    }
}
