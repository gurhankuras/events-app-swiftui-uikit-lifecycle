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

class ChatRoomsViewController: UITableViewController {
    lazy var scrollAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animator.addAnimations {
            if animator.isRunning {
                return
            }
            
            
        }
        return animator
    }()
    
    lazy var popup: UIView = {
        let p = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        p.addGestureRecognizer(tap)
        p.isUserInteractionEnabled = true
        p.backgroundColor = .purple
        p.translatesAutoresizingMaskIntoConstraints = false
        p.layer.cornerRadius = 25
        
        let image = UIImage(systemName: "house")
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        p.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: p.centerYAnchor)
        ])
        p.isHidden = true
        return p
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.popup.alpha = 0
        }, completion: { _ in
            self.popup.isHidden = true
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatRoomCell2.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                              for: .valueChanged)
        tableView.refreshControl?.tintColor = .purple
        view.addSubview(popup)
        
        NSLayoutConstraint.activate([
            popup.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            popup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            popup.widthAnchor.constraint(equalToConstant: 50),
            popup.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //view.bringSubviewToFront(popup)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatRoomCell2
        //cell.largeContentTitle = "deneme"
        return cell
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        popup.isHidden = false
        print("Scrolled To Top")
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("will begin accelarated")
    }
    
    
    
    
   
      
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
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
