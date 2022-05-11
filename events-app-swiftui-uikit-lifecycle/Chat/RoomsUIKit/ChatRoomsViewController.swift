//
//  ChatRoomsViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/25/22.
//

import Foundation

import UIKit

extension UIView {
    var isAnimating: Bool {
        return (self.layer.animationKeys()?.count ?? 0) > 0
    }
}

import Combine

class ChatRoomsViewController: UITableViewController {
    var animator: UIViewPropertyAnimator?
    let viewmodel: ChatRoomsViewModel
    var cancellable: AnyCancellable?
    
    init(viewmodel: ChatRoomsViewModel) {
        self.viewmodel = viewmodel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var popup: UIView = {
        let scrollPopup = ScrollPopup()
        scrollPopup.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scrollPopup.addGestureRecognizer(tap)
        return scrollPopup
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.popup.alpha = 0
        }, completion: { _ in
            self.popup.isHidden = true
        })
    }
    
    @objc func addTapped() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, animations: {
            self.navigationController?.isNavigationBarHidden = false
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = viewmodel.$rooms.sink(receiveValue: { [weak self] rooms in
            self?.tableView.reloadData()
        })
        
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(addTapped))

        print( navigationController?.navigationItem.rightBarButtonItem )
        tableView.register(ChatRoomCell2.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        setRefreshControl()
        configureSubviews()
        viewmodel.load(for: .init(id: "12", email: "gurhankuras@hotmail.com", image: "deneme"))
    }
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl.tintColor = .appPurple
        tableView.refreshControl = refreshControl
    }
    
    private func configureSubviews() {
        view.addSubview(popup)
        
        NSLayoutConstraint.activate([
            popup.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            popup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            popup.widthAnchor.constraint(equalToConstant: 50),
            popup.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
 
}


// MARK: ScrollView
extension ChatRoomsViewController {
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        popup.isHidden = false
        print("Scrolled To Top")
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("will begin accelarated")
    }
}

// MARK: TableView
extension ChatRoomsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatRoomCell2
        let room = viewmodel.rooms[indexPath.row]
        cell.setRoom(room)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.rooms.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = viewmodel.rooms[indexPath.row]
        room.select?(room)
    }
    
}

// MARK: Scroll Button
extension ChatRoomsViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offSetY = targetContentOffset.pointee.y
        handleScrollButtonPresentation(offsetY: offSetY)
    }
    
    private func handleScrollButtonPresentation(offsetY: CGFloat) {
        let totalOffsetY = offsetY + view.safeAreaInsets.top
        print(totalOffsetY)

        guard !self.popup.isAnimating else { return }
        if shouldShowScrollButton(totalOffsetY: totalOffsetY) {
            showScrollButton()
        }
        else if totalOffsetY <= 300.0 && !self.popup.isHidden {
            hideScrollButton()
        }
    }
    
    private func shouldShowScrollButton(totalOffsetY: CGFloat) -> Bool {
        totalOffsetY > 300.0 && self.popup.isHidden
    }
    
    private func showScrollButton() {
        self.popup.alpha = 0
        self.popup.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.popup.alpha = 1
        }) { completed in
        }
    }
    
    private func hideScrollButton() {
        UIView.animate(withDuration: 1, animations: {
            self.popup.alpha = 0

        }) { completed in
            self.popup.isHidden = true
        }
    }
}



/*

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ChatRoomsViewController()
        }
    }
}
#endif
*/
