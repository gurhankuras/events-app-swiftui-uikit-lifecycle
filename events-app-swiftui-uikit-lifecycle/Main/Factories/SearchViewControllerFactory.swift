//
//  SearchViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit


class SearchViewControllerFactory {
    func controller() -> UINavigationController {
        let viewModel = SearchViewModel()
        let tableVc = SearchTableViewController(viewModel: viewModel)
        let vc = SearchViewController(viewModel: viewModel, resultsTable: tableVc)
        let controller = UINavigationController(rootViewController: vc)
        
        controller.navigationBar.prefersLargeTitles = false
        controller.isNavigationBarHidden = true
        return controller
    }
}
