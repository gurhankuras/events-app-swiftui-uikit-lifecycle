//
//  LiveChatTableViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//

import Foundation
import UIKit


/*
 
 //
 //  SocketIORoomRealTimeListener.swift
 //  events-app-swiftui-uikit-lifecycle
 //
 //  Created by Gürhan Kuraş on 3/28/22.
 //

 import Foundation
 import SocketIO


 class SocketIORoomRealTimeListener: RoomRealTimeListener {
     //var onReceive: ((RemoteChatRoom) -> Void)?

     struct DecodingError: Error {}

     let logger = AppLogger(type: SocketIOChatCommunicator.self)
     let manager: SocketManager
     let socket: SocketIOClient!
     let tokenStore: TokenStore
     
     deinit {
         logger.e(#function)
         socket.disconnect()
         socket.removeAllHandlers()
     }
     
     init(manager: SocketManager, tokenStore: TokenStore) {
         self.tokenStore = tokenStore
         self.manager = manager
         self.socket = SocketIOClient(manager: manager, nsp: "/room")
         setToken(conf: &manager.config)

         socket.on(clientEvent: .connect) {[weak self] data, ack in
             self?.logger.i("connection established!")
             self?.logger.i(data)
         }
         
         socket.on(clientEvent: .disconnect) { data, ack in
             print("disconnected")
         }
         
         socket.on(clientEvent: .reconnect) { data, ack in
             print("reconnecting")
         }
         
         manager.connect()
         //receive()
     
         
     }
     
     private func setToken(conf: inout SocketIOClientConfiguration) {
         if let token = tokenStore.get() {
             conf.insert(.extraHeaders(["access-token": token]))
         }
     }
     
     func receive(completion: @escaping (RemoteChatRoom) -> Void) {
         print(ServerChatEvent.roomUpdated.rawValue)
         
         socket.on(ServerChatEvent.roomUpdated.rawValue) { data, ack in
                 print(data)
         }
         /*
         socket.on(ServerChatEvent.roomUpdated.rawValue) { [weak self] rawData, ack in
             self?.logger.d(rawData)
             DispatchQueue.global(qos: .default).async {
                 guard let jsonString = rawData[0] as? String,
                       let data = jsonString.data(using: .utf8),
                       let room = try? JSONDecoder.withFractionalSecondISO8601.decode(RemoteChatRoom.self, from: data)
                 else {
                     print("An error occured while decoding RemoteChatRoom")
                     return
                 }
                 //self?.onReceive?(room)
                 completion(room)
             }
         }
          */
         
     }
 }

 */

struct LiveChatMessage {
    let image: String
    let timestamp: String
    let username: String
    let text: String
}


import Combine
import os
import SocketIO




struct LiveChatMessageDto: Codable {
    let name: String
    let room: String
}



class LiveChatTableViewController: UITableViewController {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LiveChatTableViewController.self))
    
    private static let cellIdentifier = "cell"
    //private let scrollSubject = CurrentValueSubject<Bool, Never>(false)
    var cancellables = Set<AnyCancellable>()
    let viewModel = LiveChatViewModel()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        tableView.scrollToRow(at: IndexPath(row: viewModel.messages.value.count - 1, section: 0), at: .bottom, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
       
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        configureTableView()
        addScrollerButton()
        
        viewModel.messages.sink { [weak self] msgs in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: msgs.count - 1, section: 0), at: .bottom, animated: true)
        }
       
        .store(in: &cancellables)
    }
    
    var scrollerButtonTrailingConstraint: NSLayoutConstraint!
    
    @objc func tap() {
        Self.logger.log("tap")
        scrollerButtonTrailingConstraint.constant = 400
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
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
    
    func addScrollerButton() {
        view.addSubview(scrollerButton)
        
        scrollerButtonTrailingConstraint = scrollerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 400)
        scrollerButtonTrailingConstraint.isActive = true
        scrollerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollerButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        scrollerButton.heightAnchor.constraint(equalTo: scrollerButton.widthAnchor).isActive = true
    }
    
    
    
    
    
    private func configureTableView() {
        tableView.register(LiveChatMessageCell.self, forCellReuseIdentifier: Self.cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as! LiveChatMessageCell
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
