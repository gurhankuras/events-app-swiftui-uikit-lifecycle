//
//  VideoPlayerTests.swift
//  playTests
//
//  Created by Gürhan Kuraş on 2/21/22.
//

import XCTest
import Combine
@testable import events_app_swiftui_uikit_lifecycle
import AVFoundation

class VideoPlayerTests: XCTestCase {
    let logger = AppLogger(type: VideoPlayerTests.self)

    func test_startsWithPlayingState() {
        let (vm, _) = makePlayerViewModel()
        let spy = TestSpyNever(vm.$playState.eraseToAnyPublisher(), dropFirst: false)
        
        XCTAssertEqual(spy.values.count, 1)
        XCTAssert(spy.values.first is PlayerViewModel.PlayingState)
    }
    
    func test_transitionsFromPlayingToPaused() {
        // Arrange
        let (vm, _) = makePlayerViewModel()
        let stateSpy = TestSpyNever(vm.$playState.eraseToAnyPublisher())
        
        // Act
        vm.playState.next()
        
        // Assert
        logger.i(stateSpy.values)
        XCTAssertEqual(stateSpy.values.count, 1)
        XCTAssert(stateSpy.values.last is PlayerViewModel.PausedState)
    }
    
    func test_shouldShowPanelWhenStartedPlayingByUser() {
        let (vm, _) = makePlayerViewModel()
        let spy = TestSpyNever(vm.$showingControls.eraseToAnyPublisher())
        XCTAssert(vm.playState is PlayerViewModel.PlayingState)
        
        vm.playState.next()
        
        XCTAssertEqual(vm.showingControls, true)
    }
    
    func test_shouldShowPanelWhenPausedByUser() {
        let (vm, _) = makePlayerViewModel()
        let spy = TestSpyNever(vm.$showingControls.eraseToAnyPublisher())
        XCTAssert(vm.playState is PlayerViewModel.PlayingState)
        
        vm.playState.next()
        vm.playState.next()
        
        XCTAssertEqual(vm.showingControls, true)
    }
}

extension VideoPlayerTests {
    func makePlayerViewModel() -> (PlayerViewModel, AVPlayer) {
        let url = Bundle.main.url(forResource: "sample", withExtension: "mp4")
        let player = AVPlayer(url: url!)
        let vm = PlayerViewModel(player: player)
        return (vm, player)
    }
}


class TestTransformerSpy<T, U> {
    private(set) var values = [U]()
    private var cancellable: AnyCancellable?
    private var mapper: (T) -> U
    
    init(_ publisher: AnyPublisher<T, Never>, mapper: @escaping (T) -> U) {
        self.mapper = mapper
        cancellable = publisher.sink { [weak self] value in
           guard let self = self else { return }
           let transformed = self.mapper(value)
           self.values.append(transformed)
        }
    }
}


class FakePlayer {
    var currentItem: AVPlayerItem? {
        return AVPlayerItem(url: URL(string: "")!)
    }
    
    func pause() {
        
    }
    
    func play() {
        
    }
    
    
}
