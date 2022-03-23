//
//  FullscreenVideoPage.swift
//  play
//
//  Created by Gürhan Kuraş on 2/24/22.
//

import SwiftUI

struct FullscreenVideoPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var videoPlayerViewModel: PlayerViewModel
    var body: some View {
        return ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            GKVideoPlayer(fullscreen: true,
                          player: videoPlayerViewModel.player)
            VideoPlayerOverlayPanelContainer(viewModel: videoPlayerViewModel,
                                             onDismiss: { presentationMode.wrappedValue.dismiss() })
                .opacity(videoPlayerViewModel.showingControls ? 1 : 0)
            
        }
        .onTapGesture {
            withAnimation(.spring()) {
                videoPlayerViewModel.showingControls.toggle()
            }
        }
        
        .onAppear {          
            DispatchQueue.main.async {
                AppDelegate.rotateScreen(to: .landscape)
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                AppDelegate.rotateScreen(to: .portrait)
            }
        }
         
    }
}


/*
struct FullscreenVideoPage_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenVideoPage()
    }
}
*/
