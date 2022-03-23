//
//  PlayerViewModel.swift
//  play
//
//  Created by Gürhan Kuraş on 2/20/22.
//

import Foundation
import AVKit
import Combine



struct PlayerOptions {
    let hidesPanelAfterSeconds: Double
    let interactionThrottleTimeInSeconds: Double
    
    init(hidesPanelAfterSeconds: Double = 5.0,
         interactionThrottleTimeInSeconds: Double = 1.0) {
        self.hidesPanelAfterSeconds = hidesPanelAfterSeconds
        self.interactionThrottleTimeInSeconds = interactionThrottleTimeInSeconds
    }
    
    static func `default`() -> PlayerOptions {
        PlayerOptions()
    }
}


class PlayerViewModel: ObservableObject {
    
    private let logger = AppLogger(type: PlayerViewModel.self)
    private var timeObserverSub: Any?
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private let touchDetector = PassthroughSubject<Void, Never>()
    
    private let options: PlayerOptions
    let player: AVPlayer
    
    @Published var videoProgress: Double = 0.0
    @Published var playState: PlayerState
    @Published var showingControls = true
    @Published var isTracking = false
    @Published var isFullscreen = false
    
    init(player: AVPlayer, options: PlayerOptions = PlayerOptions()) {
        self.player = player
        self.options = options
        
        var firstState = PausedState()
        
        self._playState = .init(initialValue: firstState)
        firstState.setViewModel(self)
        start()
        //setupPanelHidingSub()
        $playState.sink { state in
            print(state)
        }.store(in: &cancellables)
        touchDetector.send()
    }
    
    var totalDurationInSeconds: Double? {
        guard let total = player.currentItem?.duration.seconds, !total.isNaN else {
            return nil
        }
        return total
    }
    
    
    var formattedDuration: String {
        guard let totalDurationInSeconds = totalDurationInSeconds else {
            return ""
        }

        let seconds = videoProgress * totalDurationInSeconds
        let interval = TimeInterval(seconds)

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = ((seconds / 3600) < 1) ? [.minute, .second] : [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let formattedString = formatter.string(from: interval)
        return formattedString ?? ""
    }
    
    private func start() {
        playState = PausedState(viewModel: self)
        playState.next()
        listenPassedTime()
    }
    
    private func listenPassedTime() {
        timeObserverSub = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: .main) { [weak self] time in
            guard let self = self else { return }

            self.logger.d(self.videoProgress)
            self.updateProgress(with: time)
        }
    }
    
    private func setupPanelHidingSub() {
        $showingControls
            .combineLatest(throttledControlsInteractions)
            .sink { [weak self] (show, _) in
                guard let self = self else { return }
                self.logger.d("in sink")
                self.timer?.invalidate()
                if show {
                    self.logger.d("in condition")

                    self.timer = Timer.scheduledTimer(withTimeInterval: self.options.hidesPanelAfterSeconds, repeats: false) { timer in
                        self.showingControls = false
                        timer.invalidate()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private var throttledControlsInteractions: AnyPublisher<Void, Never> {
        let throttleSeconds = self.options.interactionThrottleTimeInSeconds
        return touchDetector
            .throttle(for: RunLoop.SchedulerTimeType.Stride(throttleSeconds), scheduler: RunLoop.main, latest: false)
            .eraseToAnyPublisher()
    }
    
    
    deinit {
        logger.i(videoProgress)
        logger.e("PLAYERVIEWMODEL DEINIT")
        removeTimeObserverIfSubscribed()
    }
    
    private func removeTimeObserverIfSubscribed() {
        if timeObserverSub != nil {
            // print("BIR KEZ GIRMELI")
            player.removeTimeObserver(timeObserverSub!)
        }
    }
    
    
   
    
    func onSlide(tracking: Bool, with value: Float) {
        touchDetector.send()
        
        if playState is PlayerViewModel.FinishedState {
            playState.next()
        }
        
        if tracking {
            player.pause()
            logger.i("slider value: \(value)\n\(player.currentItem!.duration.seconds)")
            let sec = Double(Double(value) * player.currentItem!.duration.seconds)
            player.seek(to: CMTime(seconds: sec, preferredTimescale: player.currentItem!.duration.timescale))
        }
        // released
        else {
            logger.i("slider value: \(value)\n\(player.currentItem!.duration.seconds)")
            
            let sec = Double(Double(value) * player.currentItem!.duration.seconds)
            player.seek(to: CMTime(seconds: sec, preferredTimescale: player.currentItem!.duration.timescale))
        
            if playState is PlayerViewModel.PlayingState {
                player.play()
            }
         
        }
         
    }
    
    func add(seconds time: Double) {
        touchDetector.send()
        guard let totalDurationInSeconds = totalDurationInSeconds else {
            return
        }

        let futureTimePoint = player.currentTime().seconds + time
        let futureProgress = futureTimePoint / totalDurationInSeconds
        
        //let sec = Double(Double(value) * player.currentItem!.duration.seconds)
        videoProgress = futureProgress
        player.seek(to: CMTime(seconds: futureTimePoint, preferredTimescale: player.currentItem!.duration.timescale))
    }
    
    func updateProgress(with time: CMTime) {
        guard let totalDurationInSeconds = totalDurationInSeconds else {
            return
        }

        self.videoProgress = time.seconds / totalDurationInSeconds
        // logger.i("updateVideoProgress RUN, progress: \(videoProgress)")
        
        if videoProgress == 1.0 {
            showingControls = true
            logger.d("Video finished!")
            playState.next()
        }
    }
}


protocol PlayerState {
    var viewModel: PlayerViewModel! { get set }
    var icon: String { get }
    mutating func setViewModel(_ viewModel: PlayerViewModel)
    func next()
}

extension PlayerState {
    mutating func setViewModel(_ viewModel: PlayerViewModel) {
        self.viewModel = viewModel
    }
}

extension PlayerViewModel {
  struct PlayingState: PlayerState {
      weak var viewModel: PlayerViewModel!
      var icon: String { "pause.fill" }

      init() {}

      init(viewModel: PlayerViewModel) {
          self.viewModel = viewModel
          viewModel.touchDetector.send()
          viewModel.player.play()
      }

      func next() {
          if viewModel.videoProgress == 1.0 {
              viewModel.playState = FinishedState(viewModel: viewModel)
              return
          }
          viewModel.playState = PausedState(viewModel: viewModel)
      }
  }

    struct PausedState: PlayerState {
        weak var viewModel: PlayerViewModel!
        var icon: String { "play.fill" }
        
        init() {}
        
        init(viewModel: PlayerViewModel) {
            self.viewModel = viewModel
            viewModel.touchDetector.send()
            viewModel.player.pause()
        }
        
        func next() {
            viewModel.playState = PlayingState(viewModel: viewModel)
        }
    }

    struct FinishedState: PlayerState {
        weak var viewModel: PlayerViewModel!
        var icon: String { "arrow.clockwise" }
        
        init() {}
        
        init(viewModel: PlayerViewModel) {
            self.viewModel = viewModel
        }

        func next()  {
            viewModel.player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            viewModel.playState = PlayingState(viewModel: viewModel)
        }
    }
}
