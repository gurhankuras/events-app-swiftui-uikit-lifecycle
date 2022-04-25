//
//  RoomViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/28/22.
//

import Foundation

struct RoomViewModel: Identifiable {

    var id: String
    let imageUrl: String
    let name: String
    let message: String
    let timestamp: Date?
    let lastSender: ChatUser?
    var select: ((RoomViewModel) -> Void)?
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(for: timestamp) ?? ""
    }
}
