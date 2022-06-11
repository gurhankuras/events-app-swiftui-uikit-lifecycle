//
//  LiveChatBar.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/10/22.
//

import Foundation
import UIKit

class LiveChatBar: UIView {
    let textView = CustomTextView()
    var onSend: (() -> ())?
    lazy var sendButton: UIView = {
        let sendButton = UIView()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.layer.cornerRadius = 15
        sendButton.backgroundColor = .systemPink
        let imageView = UIImageView(image: UIImage(systemName: "paperplane.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 10
        sendButton.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickSendButton))
        sendButton.addGestureRecognizer(tap)
        return sendButton
    }()
    
    func setActiveStatusForButton(_ active: Bool) {
        //sendButton.backgroundColor = active ? .systemPink : .gray
        sendButton.layer.opacity = active ? 1 : 0.5
    }
    
    @objc private func clickSendButton() {
        print("tap tap")
        onSend?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
       
        addSubview(sendButton)

        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        translatesAutoresizingMaskIntoConstraints = false
        text = ""
        isScrollEnabled = true
        font = .systemFont(ofSize: 14, weight: .regular)
        sizeToFit()
        backgroundColor = .systemGray6
        isScrollEnabled = false
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

