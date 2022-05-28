//
//  PlaceholderEventCardView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/28/22.
//

import Foundation
import SwiftUI

struct DummyEventCardView: View {
    var body: some View {
        EventCardView(event: .stub, onClicked: {_ in })
    }
}
