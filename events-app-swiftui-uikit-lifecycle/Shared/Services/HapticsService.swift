//
//  HapticService.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/22/22.
//

import Foundation
import UIKit
import CoreHaptics

class HapticsService {
    static let shared = HapticsService()
    
    
    func vibrate() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
}
