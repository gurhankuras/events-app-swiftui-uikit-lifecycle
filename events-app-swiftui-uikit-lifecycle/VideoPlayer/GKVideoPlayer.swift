//
//  GKVideoPlayer.swift
//  play
//
//  Created by Gürhan Kuraş on 2/24/22.
//

import SwiftUI
import AVKit

struct GKVideoPlayer: UIViewControllerRepresentable {
    let fullscreen: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        print("sadasdas")
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        uiViewController.player = nil
        print("DISMANTLE")
    }
    
    typealias UIViewControllerType = AVPlayerViewController
    
    class Coordinator: NSObject {
       // weak var controller: AVPlayerViewController?
        
        deinit {
            print("COORDINATRO DEINIT")
        }
    }
    
}

/*
struct GKVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        GKVideoPlayer(fullscreen: true, player: <#T##AVPlayer#>)
    }
}
*/
