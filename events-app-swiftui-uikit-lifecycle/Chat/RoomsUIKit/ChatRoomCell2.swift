//
//  ChatRoomCell.swift
//  events_uikit
//
//  Created by Gürhan Kuraş on 4/25/22.
//

import Foundation
import UIKit

class ChatRoomCell2: UITableViewCell {
    lazy var image: UIImageView = {
        let image = UIImage(named: "pikachu")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var chatTitle: UILabel = {
        let label = UILabel()
        label.text = "Gurhan"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateTime: UILabel = {
        let label = UILabel()
        label.text = "15:24"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lastMessageText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let senderName = "Ali: "
        let senderAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string: senderName, attributes: senderAttributes)
        let messageText = "Bugun hava cok guzeldi ama ben bu kadarini da beklemiyordum pes dogrusu hahahah ne de guzel oldu be hahaha degil mi sence de"
        
        let messageTextAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        attributedString.append(.init(string: messageText, attributes: messageTextAttributes))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setRoom(_ room: RoomViewModel) {
        let senderName = room.lastSender != nil ? "\(room.lastSender!.name): ": ""
        let senderAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string: senderName, attributes: senderAttributes)
        let messageText = room.message
        
        let messageTextAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        attributedString.append(.init(string: messageText, attributes: messageTextAttributes))
        lastMessageText.attributedText = attributedString
        
        chatTitle.text = room.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        addSubview(image)
        addSubview(chatTitle)
        addSubview(dateTime)
        addSubview(lastMessageText)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            image.widthAnchor.constraint(equalToConstant: 65),
            image.heightAnchor.constraint(equalToConstant: 65),
            image.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            chatTitle.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            chatTitle.topAnchor.constraint(equalTo: image.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dateTime.topAnchor.constraint(equalTo: image.topAnchor)
        ])
    
        NSLayoutConstraint.activate([
            lastMessageText.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            lastMessageText.topAnchor.constraint(equalTo: chatTitle.bottomAnchor, constant: 5),
            lastMessageText.trailingAnchor.constraint(equalTo: dateTime.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
