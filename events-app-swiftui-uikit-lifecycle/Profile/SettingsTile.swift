//
//  SettingsTile.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/28/22.
//

import SwiftUI

struct SettingsTile<Content: View>: View {
    let title: LocalizedStringKey
    let icon: String
    @ViewBuilder let content: () -> Content
    
    init(title: LocalizedStringKey, icon: String, content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }
    var body: some View {
        settingBody
        .foregroundColor(Color.primary)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 40)
        .background(Color(UIColor.systemBackground))
    }
    
    var settingBody: some View {
        HStack {
            Label {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            } icon: {
                Image(systemName: icon)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
            content()
        }
    }
    /*
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
     */
}



struct SettingsTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsTile(title: "Automatic (follow iOS setting)", icon: "gearshape") {
                Toggle(isOn: .constant(true), label: {})
                    .frame(width: 60)
                  .tint(.blue)
            }
            /*
            SettingsTile(setting: ProfileSetting(name: "Language", icon: "network", type: .link({})), content: {EmptyView()})
            SettingsTile(setting: ProfileSetting(name: "Language", icon: "network", type: .multiselect("Turkish")), content: {EmptyView()})
        */
             }
        .previewLayout(.sizeThatFits)
    }
}

