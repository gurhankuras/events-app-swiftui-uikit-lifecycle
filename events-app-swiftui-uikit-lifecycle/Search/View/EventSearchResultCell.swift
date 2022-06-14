//
//  EventSearchResultCell.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation
import UIKit


struct SearchedEventViewModel {
    private let startingDate: Date
    private let address: RemoteNearEventAddress
    let title: String
    
    init(_ event: SearchedEvent) {
        self.startingDate = event.at
        self.address = event.address
        self.title = event.title
    }
    
    
    var monthSymbol: String {
        let components = Calendar.current.dateComponents([.month], from: startingDate)
        guard let month = components.month else { return "-" }
        let monthName = DateFormatter().monthSymbols[month - 1].prefix(3).uppercased()
        return monthName
    }
    
    var day: String {
        let components = Calendar.current.dateComponents([.day], from: startingDate)
        guard let day = components.day else { return "-" }
        return String(day)
    }
    
    var shortAddress: String {
        return "\(address.city), \(address.district)"
    }
}

struct SearchedEvent: Identifiable, Decodable {
    let id: String
    let at: Date
    let image: String
    let title: String
    let description: String
    //let createdAt: Date?
    let latitude: Double
    let longitute: Double
    let address: RemoteNearEventAddress
}



class EventSearchResultCell: UITableViewCell {
    private(set) var viewModel: SearchedEventViewModel?
    
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
    
    
    func setViewModel(_ viewModel: SearchedEventViewModel) {
        self.viewModel = viewModel
        refreshWithNewEvent()
    }
    
    func refreshWithNewEvent() {
        setDate()
        setTitle()
    }
    
    
    private func setDate() {
        guard let viewModel = viewModel else {
            return
        }
    

        let monthDayAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        
        let monthNameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
    
        let monthDayAttrStr = NSMutableAttributedString(string: viewModel.day, attributes: monthDayAttributes)
        let a = NSAttributedString(string: "\n\(viewModel.monthSymbol)", attributes: monthNameAttributes)
        monthDayAttrStr.append(a)
        dateLabel.attributedText = monthDayAttrStr
        dateLabel.textAlignment = .center
    }
    
    private func setTitle() {
        titleLabel.text = viewModel?.title
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
