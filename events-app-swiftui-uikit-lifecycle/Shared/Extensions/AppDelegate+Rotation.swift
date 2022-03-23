//
//  AppDelegate+RotationExtension.swift
//  play
//
//  Created by Gürhan Kuraş on 3/6/22.
//

import Foundation
import UIKit


extension AppDelegate {
    enum Orientation {
        case portrait
        case landscape
        
        var mask: (UIInterfaceOrientationMask, UIInterfaceOrientation) {
            switch self {
            case .portrait:
                return (UIInterfaceOrientationMask.portrait, UIInterfaceOrientation.portrait)
            case .landscape:
                return (UIInterfaceOrientationMask.landscape, UIInterfaceOrientation.landscapeLeft)
            }
        }
    }
    
    static func rotateScreen(to orientation: Orientation) {
        let (mask, orientation) = orientation.mask
        AppDelegate.orientationLock = mask
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
/*
 
 
 DispatchQueue.main.async {

   GKAppDelegate.orientationLock = UIInterfaceOrientationMask.portrait

   UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

   UINavigationController.attemptRotationToDeviceOrientation()

 }

})

.onAppear(perform: {
   print("Fullscreen onAppear")
   GKAppDelegate.orientationLock = UIInterfaceOrientationMask.landscape
   UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
   UINavigationController.attemptRotationToDeviceOrientation()
})
 */
