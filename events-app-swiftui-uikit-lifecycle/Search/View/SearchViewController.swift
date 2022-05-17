//
//  SearchViewController.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit


class SearchViewController: UIViewController {
    let viewModel: SearchViewModel
    
    private let resultsTable: SearchTableViewController
    private let textField: UITextField = CustomSearchBar()
    
    init(viewModel: SearchViewModel, resultsTable: SearchTableViewController) {
        self.viewModel = viewModel
        self.resultsTable = resultsTable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addChild(resultsTable)
        resultsTable.didMove(toParent: self)
        view.addSubview(resultsTable.view)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(textField)
        setConstraintsForResultsTable()
        setConstraintsForTextField()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.load(for: text)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func setConstraintsForResultsTable() {
        resultsTable.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            resultsTable.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTable.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTable.view.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            resultsTable.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setConstraintsForTextField() {
        let constraints = [
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 35),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SearchViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SearchViewController(viewModel: .init(), resultsTable: .init(viewModel: .init()))
        }
    }
}
#endif


/*
let v = UIView()
v.translatesAutoresizingMaskIntoConstraints = false
let field = UITextField()
field.translatesAutoresizingMaskIntoConstraints = false
field.font = .systemFont(ofSize: 15)
field.backgroundColor = .clear
field.placeholder = "Search event"
v.backgroundColor = .background
v.layer.cornerRadius = 15
v.clipsToBounds = true
v.layer.masksToBounds = true
v.layer.borderWidth = 1
v.layer.borderColor = UIColor.black.cgColor
v.addSubview(field)

NSLayoutConstraint.activate([
    field.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 10),
    field.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10),
    field.topAnchor.constraint(equalTo: v.topAnchor),
    field.bottomAnchor.constraint(equalTo: v.bottomAnchor),
])

//field.isScrollEnabled = true
//field.textContainer.maximumNumberOfLines = 1
//field.textContainer.lineBreakMode = .byClipping

return v
 */
