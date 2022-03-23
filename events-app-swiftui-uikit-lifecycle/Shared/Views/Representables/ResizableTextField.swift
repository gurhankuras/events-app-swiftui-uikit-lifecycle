//
//  ResizableTextField.swift
//  play
//
//  Created by Gürhan Kuraş on 3/14/22.
//

import Foundation
import SwiftUI
import UIKit

// https://www.youtube.com/watch?v=E5W5aYZAOdU&list=WL&index=1
struct ResizableTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = "Enter Text"
        view.font = .systemFont(ofSize: 18)
        view.textColor = .gray
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print(#function)
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
            uiView.text = text
        }
    }
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ResizableTextField
        
        init(parent: ResizableTextField) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            print(#function)
            if self.parent.text == "" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print(#function)
            
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
    
}