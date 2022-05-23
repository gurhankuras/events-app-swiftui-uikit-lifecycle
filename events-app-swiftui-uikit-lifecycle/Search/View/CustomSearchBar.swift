//
//  CustomSearchBar.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit

class CustomSearchBar: UITextField, UITextFieldDelegate {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 25.0, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 15)
        backgroundColor = .clear
        delegate = self
        placeholder = "search-event".localized()
        backgroundColor = .background
        returnKeyType = .done
        layer.cornerRadius = 15
        clipsToBounds = true
        self.keyboardType = .default
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
