//
//  DescriptionTextViewDelegate.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import Foundation
import UIKit

class DescriptionTextViewDelegate: NSObject, UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("deneme")
        return true
    }
}
