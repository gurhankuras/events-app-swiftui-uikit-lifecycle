//
//  LiveStreamView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation

import SwiftUI
import AVKit

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        translatesAutoresizingMaskIntoConstraints = false
        text = ""
        textContainer?.maximumNumberOfLines = 3
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

class LiveChatBar: UIView {
    let textView = CustomTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        let sendButton = UIView()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.layer.cornerRadius = 15
        sendButton.backgroundColor = .systemPink
        let imageView = UIImageView(image: UIImage(systemName: "paperplane.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.addSubview(imageView)
        addSubview(sendButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            //sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.topAnchor.constraint(equalTo: topAnchor),
            //sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LiveStreamContainerViewController: UIViewController {
    var textViewBottomContraint: NSLayoutConstraint!
    var liveChatViewControllerBottomConstraint: NSLayoutConstraint!
    
    lazy var videoPlayerController: AVPlayerViewController = {
       let viewController = AVPlayerViewController()
        viewController.player = AVPlayer(url: URL(string: "http://\(hostName):8080/hls/test.m3u8")!)
        return viewController
    }()
    
    let chatBar = LiveChatBar()
    
    let liveChatViewController = LiveChatTableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        addChild(videoPlayerController)
        videoPlayerController.didMove(toParent: self)
        view.addSubview(videoPlayerController.view)
        
        videoPlayerController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoPlayerController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoPlayerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayerController.view.heightAnchor.constraint(equalTo: videoPlayerController.view.widthAnchor, multiplier: 9/16)
        ])
        
        
        addChild(liveChatViewController)
        liveChatViewController.didMove(toParent: self)
        view.addSubview(liveChatViewController.view)
        
        liveChatViewController.view.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            liveChatViewController.view.topAnchor.constraint(equalTo: videoPlayerController.view.bottomAnchor),
            liveChatViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            liveChatViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        liveChatViewControllerBottomConstraint = liveChatViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        liveChatViewControllerBottomConstraint.isActive = true
         
        view.addSubview(chatBar)

        NSLayoutConstraint.activate([
            chatBar.topAnchor.constraint(equalTo: liveChatViewController.view.bottomAnchor),
            chatBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        textViewBottomContraint = chatBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        textViewBottomContraint.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        //textViewBottomContraint.constant = -keyboardHeight
        liveChatViewControllerBottomConstraint.constant = -(keyboardHeight + 50)
        textViewBottomContraint = chatBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.chatBar.textView.textColor = .white
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.liveChatViewController.scrollToBottom()
        }

        print(keyboardHeight)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).height
        //textViewBottomContraint.constant = 0
        textViewBottomContraint = chatBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        liveChatViewControllerBottomConstraint.constant = -50
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.chatBar.textView.textColor = .gray
                self.view.layoutIfNeeded()
            }, completion: nil)
        print(keyboardHeight)
    }
}

