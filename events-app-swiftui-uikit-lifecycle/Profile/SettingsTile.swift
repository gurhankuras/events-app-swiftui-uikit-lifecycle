//
//  SettingsTile.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI

struct SettingsTile: View {
    let setting: ProfileSetting
    var body: some View {
        
        Group {
            if setting.type.isLink {
                Button {
                    guard case let .link(action) = setting.type else { return }
                    action()
                } label: {
                    settingBody
                }
            }
            else {
                settingBody
            }
        }
        .foregroundColor(Color.primary)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(Color(UIColor.systemBackground))
    }
    
    var settingBody: some View {
        HStack {
            Label {
                Text(setting.name)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            } icon: {
                Image(systemName: setting.icon)
                    .font(.system(size: 18))
            }
            Spacer()
            TypedOptionView(type: setting.type)
        }
    }
    
    @ViewBuilder func TypedOptionView(type: SettingsType) -> some View {
        switch setting.type {
        case .toggle(let isOn):
            Toggle(isOn: isOn, label: {})
              .tint(.blue)
              //.scaleEffect(x: 1, y: 0.7, anchor: .center)
        case .link(_):
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold, design: .default))
        case .multiselect(let selected):
            HStack {
                Text(selected)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold, design: .default))
            }
        }
    }
}


struct SettingsTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsTile(setting: ProfileSetting(name: "Language", icon: "network", type: .toggle(.constant(true))))
            SettingsTile(setting: ProfileSetting(name: "Language", icon: "network", type: .link({})))
            SettingsTile(setting: ProfileSetting(name: "Language", icon: "network", type: .multiselect("Turkish")))
        }
        .previewLayout(.sizeThatFits)
    }
}
