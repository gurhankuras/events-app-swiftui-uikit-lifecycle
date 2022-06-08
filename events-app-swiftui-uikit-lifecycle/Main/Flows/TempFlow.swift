//
//  TempFlow.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation
import UIKit
import SwiftUI


class TempFlow: Flow {
    var window: UIWindow?
    func start() {
        window?.rootViewController = LiveStreamContainerViewController()
    }
    
    
}
