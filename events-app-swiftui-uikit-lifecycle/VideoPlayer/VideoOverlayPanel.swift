//
//  VideoOverlayPanel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/21/22.
//

import SwiftUI
import AVKit

struct VideoPlayerOverlayPanelContainer: View {
    @ObservedObject var viewModel: PlayerViewModel
    let onDismiss: (() -> Void)?
    
    var body: some View {
        VideoPlayerOverlayPanel(
            onBackward: { viewModel.add(seconds: -10) },
            onForward: { viewModel.add(seconds: 10) },
            onAction: { viewModel.playState.next() },
            onSlide: viewModel.onSlide,
            videoProgress: $viewModel.videoProgress,
            fullscreen: $viewModel.isFullscreen,
            progressText: viewModel.formattedDuration,
            icon: viewModel.playState.icon,
            onDismiss: onDismiss
        )
    }
}

struct VideoPlayerOverlayPanel: View {
    let onBackward: () -> Void
    let onForward: () -> Void
    let onAction: () -> Void
    let onSlide: (_ tracking: Bool, _ value: Float) -> Void
    
    @Binding var videoProgress: Double
    @Binding var fullscreen: Bool
    let progressText: String
    
    let icon: String
    let onDismiss: (() -> Void)?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "backward.fill")
                    .videoControl {
                        onBackward()
                    }
                Spacer()
                Image(systemName: icon)
                    .videoControl(font: .title) {
                        onAction()
                    }
                Spacer()
                Image(systemName: "forward.fill")
                    .videoControl {
                        onForward()
                    }
            }
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .overlay(
            HStack {
                VideoPlayerProgressBar(value: $videoProgress, onSlide: onSlide)
                Text(progressText)
                    .font(.system(size: 9))
                    .foregroundColor(.white)
                if fullscreen {
                    Image(systemName: "house")
                        .foregroundColor(Color(UIColor.systemPink))
                        .onTapGesture(perform: {
                            onDismiss?()
                        })
                }
            }
            .padding(.horizontal), alignment: .bottom
        )
         
       

    }
}


struct VideoPlayerOverlayPanel_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerOverlayPanel(
            onBackward: {},
            onForward: {},
            onAction: {},
            onSlide: {_, __ in },
            videoProgress: .constant(0.4),
            fullscreen: .constant(true),
            progressText: "00:04",
            icon: "play",
            onDismiss: nil
        )
            .frame(maxWidth: .infinity)
            .frame(height: 250)
    }
}



struct VideoControlButton: ViewModifier {
    let font: Font
    let action: () -> Void
    
    func body(content: Content) -> some View {
        return Button(action: action) {
            content
                //.symbolVariant(.fill)
                .font(font)
                .foregroundColor(.white)
                .padding(20)
        }
    }
}
extension View {
    func videoControl(font: Font = .title3, action: @escaping () -> Void) -> some View {
        return modifier(VideoControlButton(font: font, action: action))
    }
}
