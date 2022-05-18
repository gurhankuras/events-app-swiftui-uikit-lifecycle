//
//  ResizebleLottieView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/18/22.
//

import SwiftUI
import Lottie
import UIKit

struct ResizebleLottieView: UIViewRepresentable {
    var fileName: String
    @Binding var isPlaying: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        addLottieView(to: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.subviews.forEach { view in
            if view.tag == 1009, let lottieView = view as? AnimationView {
                if isPlaying {
                    lottieView.play()
                }
                else {
                    lottieView.pause()
                }
            }
        }
    }
    
    func addLottieView(to view: UIView) {
        let lottieView = AnimationView(name: fileName, bundle: .main)
        lottieView.backgroundColor = .clear
        lottieView.tag = 1009
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.loopMode = .loop
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        view.addSubview(lottieView)
        NSLayoutConstraint.activate(constraints)
        //view.addConstraints(constraints)
    }
}

struct ResizebleLottieView_Previews: PreviewProvider {
    static var previews: some View {
        ResizebleLottieView(fileName: "loading", isPlaying: .constant(true))
    }
}
