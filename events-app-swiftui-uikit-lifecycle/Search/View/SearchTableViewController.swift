//
//  SearchTableViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation
import UIKit
import Lottie
import Combine


class SearchTableViewController: UITableViewController {
    private static let cellIdentifier = "cell"
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private var showsNotFound: Bool = false
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        configureTableView()
        viewModel.results
            .dropFirst()
            .sink { [weak self] events in
                guard let self = self else { return }
                
                if self.viewModel.query.value.isEmpty && self.showsNotFound {
                    self.hideNotFoundGif()
                    return
                }
                if events.isEmpty {
                    if !self.showsNotFound {
                        self.showNotFoundGif()
                    }
                } else {
                    self.hideNotFoundGif()
                }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        tableView.register(EventSearchResultCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showNotFoundGif() {
        let lottieView = AnimationView(name: "not-found-search", bundle: .main)
        lottieView.tag = 1009
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.loopMode = .loop
        let constraints = [
            lottieView.topAnchor.constraint(equalTo: view.topAnchor),
            lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ]
        
        view.addSubview(lottieView)
        view.bringSubviewToFront(lottieView)
        lottieView.play()
        NSLayoutConstraint.activate(constraints)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 1010
        label.text = "search-no-result".localized()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        lottieView.addSubview(label)
        
        let labelConstraints = [
            label.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: -40),
            label.centerXAnchor.constraint(equalTo: lottieView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        showsNotFound = true
    }
    
    private func hideNotFoundGif() {
        view.subviews.forEach { view in
            if view.tag == 1009, let lottieView = view as? AnimationView {
                lottieView.pause()
                lottieView.removeFromSuperview()
                showsNotFound = false
            }
            
            if view.tag == 1010 {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: Tableview
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as! EventSearchResultCell
        //cell.textLabel?.text = viewModel.results[indexPath.row]
        cell.setViewModel(SearchedEventViewModel(viewModel.results.value[indexPath.row]))
        //let room = viewModel.results[indexPath.row]
        //cell.setRoom(room)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.value.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let room = viewmodel.rooms[indexPath.row]
        //room.select?(room)
    }
     */
    
}
