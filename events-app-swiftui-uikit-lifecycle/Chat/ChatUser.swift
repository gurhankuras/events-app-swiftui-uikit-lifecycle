//
//  ChatUser.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/28/22.
//

import Foundation


struct ChatUser: Identifiable {
    let id: String
    let name: String
    let image: String?
    
    var select: ((ChatUser) -> Void)?
    
    init(id: String, name: String, image: String? = nil, select: ((ChatUser) -> Void)? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.select = select
    }
}
