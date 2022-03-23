//
//  ChatUserCell.swift
//  play
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUserCell: View {
    let user: ChatUser
    var body: some View {
            HStack {
                WebImage(url: URL(string: user.image ?? ""))
                    .resizable()
                    .placeholder(
                        Image("no-image")
                    )
                    .scaledToFill()
                    .size(50)
                    .clipped()
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .clipShape(Circle())
                    .padding(.trailing, 5)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(user.name)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
    }
}

struct ChatUserCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatUserCell(user: .init(id: "1", name: "Gurhan", image: nil))
    }
}
