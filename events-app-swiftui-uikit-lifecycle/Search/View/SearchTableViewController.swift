//
//  SearchTableViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation
import UIKit

class SearchTableViewController: UITableViewController {
    private static let cellIdentifier = "cell"
    private let viewModel: SearchViewModel
    
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
        viewModel.didLoad = { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.load(for: "")
    }
    
    private func configureTableView() {
        tableView.register(EventSearchResultCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: Tableview
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as! EventSearchResultCell
        //cell.textLabel?.text = viewModel.results[indexPath.row]
        cell.setEvent(event: .init(id: "1", at: Date(), image: "", title: "Sektöre yön veren yeni bir teknolojinin mimari olan yeni işlemciler olan yeni işlemciler olan yeni işlemciler", description: "Event description", createdAt: Date(), latitude: 11, longitute: 22, address: .init(city: "Istanbul", district: "Kadikoy", addressLine: nil)))
        //let room = viewModel.results[indexPath.row]
        //cell.setRoom(room)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
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
