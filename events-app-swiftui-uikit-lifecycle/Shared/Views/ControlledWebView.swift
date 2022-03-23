//
//  ControlledWebView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/19/22.
//

import SwiftUI

struct ControlledWebView: View {
    @StateObject private var webViewModel = WebViewModel()
    var body: some View {
        VStack {
            HStack {
                Button {
                    webViewModel.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .padding(.trailing)
                
                Button {
                    webViewModel.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                Spacer()
                Button {
                    webViewModel.reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                Rectangle()
                    .fill(.white)
                    .shadow(radius: 1, x: 0, y: 0)
            )
           
            WebView(viewModel: webViewModel)
        }

    }
}

struct ControlledWebView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ControlledWebView()
                .navigationBarHidden(true)
        }
    }
}
