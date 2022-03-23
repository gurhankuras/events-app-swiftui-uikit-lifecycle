//
//  ChatRoomCell.swift
//  play
//
//  Created by Gürhan Kuraş on 3/21/22.
//

import SwiftUI
import SDWebImageSwiftUI


struct ChatRoomCell: View {
    let chat: RecentChat
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: chat.imageUrl))
                    .resizable()
                    .placeholder(
                        Image(chat.imageUrl)
                    )
                    .scaledToFill()
                    .size(65)
                    .clipped()
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .clipShape(Circle())
                    .padding(.trailing, 5)
               
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(chat.name)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        Spacer()
                        Text(chat.timeAgo)
                            .font(.system(size: 12))
                            .bold()
                    }
                  
                    Text("""
                         \(
                             Text(deneme(text:chat.lastSender?.name))
                             .font(.system(size: 13))
                             .bold()
                            
                         )
                         \(chat.message)
                         """).font(.system(size: 12))
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                  
                }
                 
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
    
    func deneme(text: String?) -> String {
        text != nil ? "\(text!)" : ""
    }
    
    
     
}


struct ChatRoomCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomCell(chat: .init(id: "1", imageUrl: "pikachu", name: "Canan", message: "NasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasilsinNasi", timestamp: Date(), lastSender: .init(id: "2", name: "Ali", image: nil)))
    }
}


