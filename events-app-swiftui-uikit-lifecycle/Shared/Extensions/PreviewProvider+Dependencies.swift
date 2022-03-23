//
//  PreviewExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 2/21/22.
//

import Foundation
import SwiftUI
import AVFoundation


class PreviewDependencies {
    static let shared = PreviewDependencies()
    
    lazy var player: AVPlayer = {
        AVPlayer(url: Bundle.main.url(forResource: "sample", withExtension: "mp4")!)
    }()
    
    lazy var playerViewModel: PlayerViewModel = {
       PlayerViewModel(player: player)
    }()
    
    lazy var playingState: PlayerState = {
        PlayerViewModel.PlayingState(viewModel: playerViewModel)
    }()
    
    lazy var pausedState: PlayerState = {
        PlayerViewModel.PausedState(viewModel: playerViewModel)
    }()
    
    lazy var finishedState: PlayerState = {
        PlayerViewModel.FinishedState(viewModel: playerViewModel)
    }()
    
}

extension PreviewProvider {
    static var dev: PreviewDependencies {
        PreviewDependencies.shared
    }
}
