//
//  LiveChatTableViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation
import UIKit
import os
import RxSwift

struct LiveChatMessage {
    let image: String
    let timestamp: String
    let username: String
    let text: String
}

struct LiveChatMessageDto: Codable {
    let name: String
    let room: String
}

extension UITableView {
    func scrollToBottom(count: Int) {
        guard count > 0 else { return }
        let path = IndexPath(row: count - 1, section: 0)
        scrollToRow(at: path, at: .bottom, animated: true)
    }
}


class LiveChatTableViewController: UITableViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LiveChatTableViewController.self))

    // TODO: inject
    let viewModel = LiveChatViewModel()
    let bag = DisposeBag()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        tableView.scrollToBottom(count: viewModel.messages.value.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        configureTableView()
        viewModel.messages.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.scrollToBottom(count: $0.count)
        })
        .disposed(by: bag)
    }

    private func configureTableView() {
        tableView.register(LiveChatMessageCell.self, forCellReuseIdentifier: LiveChatMessageCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func maxContentOffset(scrollView: UIScrollView) -> CGPoint {
    return CGPoint(
        x: scrollView.contentSize.width - scrollView.bounds.width + scrollView.contentInset.right,
        y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
}

// MARK: Tableview
extension LiveChatTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveChatMessageCell.identifier) as! LiveChatMessageCell
        let message = viewModel.messages.value[indexPath.row]
        cell.setMessage(message)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.messages.value.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat  {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

/*
 lazy var scrollerButton: UIView = {
     let scrollerButton = UIView()
     scrollerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
     scrollerButton.backgroundColor = .yellow
     scrollerButton.layer.cornerRadius = 25
     scrollerButton.translatesAutoresizingMaskIntoConstraints = false
     let image = UIImage(systemName: "house")
     let imageView = UIImageView(image: image)
     imageView.translatesAutoresizingMaskIntoConstraints = false
     scrollerButton.addSubview(imageView)
     imageView.centerYAnchor.constraint(equalTo: scrollerButton.centerYAnchor).isActive = true
     imageView.centerXAnchor.constraint(equalTo: scrollerButton.centerXAnchor).isActive = true
     return scrollerButton
 }()
 */
