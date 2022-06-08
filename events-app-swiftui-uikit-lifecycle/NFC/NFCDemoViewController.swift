//
//  NFCDemoViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation
import UIKit
import CoreNFC

class NFCDemoViewController: UIViewController {
    var session: NFCTagReaderSession?
    lazy var label: UIButton = {
        var label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle("Click", for: .normal)
        label.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return label
    }()
    
    @objc func tap() {
        print("tap")
        
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = "Hold your phone near the nfc tag"
        self.session?.begin()
         
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        view.addSubview(label)
        label.backgroundColor = .systemPink
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.widthAnchor.constraint(equalToConstant: 100)
        ])
        
    }
}

extension NFCDemoViewController: NFCTagReaderSessionDelegate {
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error)
        print("Error while launching NFCReader")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("Connecting to Tag")
        guard tags.count == 1 else {
            session.alertMessage = "More than one tag detected. Please try again"
            session.invalidate()
            return
        }
        
        let tag = tags.first!
        print(tag)
        session.connect(to: tag) { error in
            guard error == nil else {
                print(error)
                session.invalidate(errorMessage: "Connection failed")
                return
            }
            
            if case let .miFare(sTag) = tag {
                let uid = sTag.identifier.map { String(format: "%.2hhx", $0) }.joined()
                print("UID: ", uid)
                session.alertMessage = "UID Captured"
                session.invalidate()
                DispatchQueue.main.async {
                    self.label.setTitle(uid, for: .normal)
                }
            }
        }
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session begun")
        
       
    }
}

