//
//  RefreshScrollViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/18/22.
//

import Foundation
import UIKit
import SwiftUI

class RefreshScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var scrollOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    
    override init() {
        print("ScrollViewModel init")
    }
    deinit {
        print("ScrollViewModel \(#function)")
    }
    
    let refreshOffsetThreshold: CGFloat = 100
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll()
    }
    
    @objc func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            print("User released Touch")
            if !isRefreshing {
                if scrollOffset > refreshOffsetThreshold {
                    isEligible = true
                } else {
                    isEligible = false
                }
            }
        }
    }
    
    func reset() {
        withAnimation(.easeIn(duration: 0.25)) {
            progress = 0
            isEligible = false
            isRefreshing = false
            scrollOffset = 0
        }
    }
}
