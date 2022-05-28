//
//  LoadingView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

import SwiftUI

struct LoadingView: View {
    @Binding var running: Bool
    var body: some View {
        ResizebleLottieView(fileName: "pink-loading", isPlaying: $running)
            .scaleEffect(1.8)
            .frame(width: 100, height: 100, alignment: .center)
            .background(
                Color.black.opacity(0.6).cornerRadius(10)
            )
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(running: .constant(true))
    }
}
