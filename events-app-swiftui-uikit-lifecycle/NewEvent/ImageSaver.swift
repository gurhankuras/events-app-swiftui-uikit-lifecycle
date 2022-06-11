//
//  ImageSaver.swift
//  play
//
//  Created by Gürhan Kuraş on 2/19/22.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(printImageSavingResult), nil)
    }
    
    @objc private func printImageSavingResult(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        print("Saved")
    }
}
