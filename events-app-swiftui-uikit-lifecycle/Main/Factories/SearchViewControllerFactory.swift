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
        let store = SecureTokenStore(keychain: .standard)
        let client = HttpAPIClient.shared.tokenSender(store: store)
        let viewModel = SearchViewModel(engine: EventSearchService(client: client))
        let tableVc = SearchTableViewController(viewModel: viewModel)
        let vc = SearchContainerViewController(viewModel: viewModel, resultsTable: tableVc)
        let controller = UINavigationController(rootViewController: vc)
        
        controller.navigationBar.prefersLargeTitles = false
        controller.isNavigationBarHidden = true
        return controller
    }
}
