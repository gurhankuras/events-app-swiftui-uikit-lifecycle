//
//  ProfileSetting.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import Foundation
import SwiftUI

struct ProfileSetting: Identifiable {
    var id: String {
        "\(name)\(icon)"
    }
    
    let name: String
    let icon: String
}


/*
enum SettingsType {
    case toggle(Binding<Bool>)
    case link(() -> ())
    case multiselect(String)
    
    var isLink: Bool {
        guard case .link(_) = self else {
            return false
        }
        return true
    }
}
*/
