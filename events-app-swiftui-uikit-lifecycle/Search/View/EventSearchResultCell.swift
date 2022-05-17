//
//  EventSearchResultCell.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation
import UIKit

struct SearchedEvent: Identifiable, Decodable {
    let id: String
    let at: Date
    let image: String
    let title: String
    let description: String
    let createdAt: Date
    let latitude: Double
    let longitute: Double
    let address: RemoteNearEventAddress
}



class EventSearchResultCell: UITableViewCell {
    private(set) var event: SearchedEvent?
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "24\nMarch"
        dateLabel.backgroundColor = .systemPink
        dateLabel.numberOfLines = 2
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        return dateLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "24\nMarch"
        //label.backgroundColor = .systemPink
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Istanbul, Pendik"
        //label.backgroundColor = .systemPink
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    func setEvent(event: SearchedEvent) {
        self.event = event
        refreshWithNewEvent()
    }
    
    private func setDate() {
        let monthDayAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        
        let monthNameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        let monthDayAttrStr = NSMutableAttributedString(string: "1", attributes: monthDayAttributes)
        let a = NSAttributedString(string: "\nSep", attributes: monthNameAttributes)
        monthDayAttrStr.append(a)
        dateLabel.attributedText = monthDayAttrStr
        dateLabel.textAlignment = .center
    }
    private func setTitle() {
        titleLabel.text = event?.title
    }
    
    func refreshWithNewEvent() {
        setDate()
        setTitle()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    private func configureSubviews() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            //dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
            //dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 15),
            locationLabel.topAnchor.constraint(equalTo:  titleLabel.bottomAnchor, constant: 8),
            //locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct EventSearchResultCell_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            //EventSearchResultCell(event: )
        }
    }
}
#endif
*/
