//
//  SettingsGroup.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI

struct SettingGroup: Identifiable {
    var id: String { section }
    let section: String
    let settings: [ProfileSetting]
}


struct SettingsGroupView: View {
    let group: SettingGroup
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(group.section.uppercased())
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            ForEach(group.settings) { setting in
                SettingsTile(setting: setting)
            }
        }
        
    }
}

/*
struct SettingsGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGroupView(
            group: SettingGroup(
                        section: "Content",
                        settings: ProfileSetting.stubs.dropLast(2)
                    )
        )
            .background(Color(r: 242, g: 235, b: 235))
            .previewLayout(.sizeThatFits)
        
    }
}
*/
