//
//  LiveStreamView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation

import SwiftUI
import AVKit
import Combine
import RxCocoa
import RxSwift
import os

class LiveStreamContainerViewController: UIViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LiveStreamContainerViewController.self))
    var textViewBottomContraint: NSLayoutConstraint!
    var liveChatViewControllerBottomConstraint: NSLayoutConstraint!
    
    
    lazy var videoPlayerController: AVPlayerViewController = {
       let viewController = AVPlayerViewController()
        viewController.player = AVPlayer(url: URL(string: "http://\(hostName):8080/hls/demo.m3u8")!)
        return viewController
    }()
    
    lazy var chatBar: LiveChatBar = {
        let bar = LiveChatBar()
        return bar
    }()
    
    let liveChatViewModel = LiveChatViewModel()
    
    let liveChatViewController = LiveChatTableViewController(style: .plain)
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        chatBar.onSend = { [weak self] in
            self?.liveChatViewModel.send()
            print("from outside")
            //self?.liveChatViewModel.text.on(.next(""))
        }
        
        chatBar.textView.rx.text
            .orEmpty
            .bind(to: liveChatViewModel.text)
            .disposed(by: bag)
        liveChatViewModel.text
            .bind(to: chatBar.textView.rx.text)
            .disposed(by: bag)
        
        liveChatViewModel.text
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { n in
                print(n)
            } onCompleted: {
                print("completed")
            }
            .disposed(by: bag)
        
        liveChatViewModel.canSendMessage.subscribe{ [weak self] canSend in
            self?.chatBar.setActiveStatusForButton(canSend)
        }
        .disposed(by: bag)


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
    
    
    
    deinit {
        Self.logger.info("deinit")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        //textViewBottomContraint.constant = -keyboardHeight
        
        
        textViewBottomContraint.isActive = false
        textViewBottomContraint = chatBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
        liveChatViewControllerBottomConstraint.constant = -(keyboardHeight + 50)
        textViewBottomContraint.isActive = true
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            //self.chatBar.textView.textColor = .white
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.liveChatViewController.scrollToBottom()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).height
        //textViewBottomContraint.constant = 0
        textViewBottomContraint.isActive = false
        textViewBottomContraint = chatBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        liveChatViewControllerBottomConstraint.constant = -50
        textViewBottomContraint.isActive = true
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                //self.chatBar.textView.textColor = .gray
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
 
}

