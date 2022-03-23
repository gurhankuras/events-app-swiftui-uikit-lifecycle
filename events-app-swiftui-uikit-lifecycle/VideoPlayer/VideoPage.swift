//
//  Chat.swift
//  play
//
//  Created by Gürhan Kuraş on 2/20/22.
//

import SwiftUI
import AVKit

struct VideoPage: View {
    @StateObject private var viewModel = PlayerViewModel(player: AVPlayer(
        url: URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    ))
    @Environment(\.scenePhase) var schenePhase
    

    var body: some View {
        return VStack {
            standartVideoScreen
            debugTexts
        }
        .fullScreenCover(isPresented: $viewModel.isFullscreen) {
            FullscreenVideoPage(videoPlayerViewModel: viewModel)
        }
        .onChange(of: schenePhase, perform: pauseWhenTransitionsToBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var standartVideoScreen: some View {
        ZStack {
            GKVideoPlayer(fullscreen: false, player: viewModel.player)
            VideoPlayerOverlayPanelContainer(viewModel: viewModel, onDismiss: nil)
                .opacity(viewModel.showingControls ? 1 : 0)
        }
        
        .frame(maxWidth: .infinity)
        .aspectRatio(16/9, contentMode: .fit)
        .background(Color.yellow)
        .clipped()
        .onTapGesture {
            withAnimation(.spring()) {
                viewModel.showingControls.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var debugTexts: some View {
        Text("videoProgress: \(viewModel.videoProgress)")
        Text("videoTotal: \(viewModel.player.currentItem!.duration.seconds)")
        Text("currentTime: \(viewModel.player.currentTime().seconds)")
        Text("progress * total: \(viewModel.videoProgress * viewModel.player.currentItem!.duration.seconds)")
        Button("Fullscreen") {
            //isPresented = true
            viewModel.isFullscreen = true
        }
        Spacer()
    }
    
    private func pauseWhenTransitionsToBackground(phase: ScenePhase) {
        if phase == .background {
            if viewModel.playState is PlayerViewModel.PlayingState {
                viewModel.playState.next()
            }
        }
    }
}



struct VideoPage_Previews: PreviewProvider {
    static var previews: some View {
        VideoPage()
    }
}
