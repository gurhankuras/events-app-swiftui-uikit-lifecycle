//
//  VideoPlayerProgressBar.swift
//  play
//
//  Created by Gürhan Kuraş on 2/21/22.
//

import SwiftUI
import AVKit

struct VideoPlayerProgressBar: UIViewRepresentable {
    @Binding var value: Double
    let onSlide: (_ tracking: Bool, _ value: Float) -> Void
    
    let logger = AppLogger(type: VideoPlayerProgressBar.self)
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, onSlide: onSlide)
    }
        
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor(.appPurple)
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = UIColor(.appLightPurple)
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        slider.value = Float(value)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        logger.d("updateView")
        uiView.value = Float(value)
    }
        
    class Coordinator {
        let onSlide: (_ tracking: Bool, _ value: Float) -> Void
        let logger = AppLogger(type: Coordinator.self)

        deinit {
            print("SliderCoordinator deinit")
        }
        
        var parent: VideoPlayerProgressBar
        init(parent: VideoPlayerProgressBar, onSlide: @escaping (_ tracking: Bool, _ value: Float) -> Void) {
            self.parent = parent
            self.onSlide = onSlide
        }
        
        @objc func changed(slider: UISlider) {
            print("changed")
            onSlide(slider.isTracking, slider.value)
        }
    }
    
}

struct VideoPlayerProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerProgressBar(value: .constant(0.4), onSlide: {_, __ in})
            .previewLayout(.sizeThatFits)
    }
}

