//
//  SearchViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/16/22.
//

import Foundation

class SearchViewModel {
    var didLoad: (([String]) -> ())?
    var results: [String] = []
    
    
    func load(for query: String) {
        self.results = [query, "Gurhan2", "Gurhan3"]
        self.didLoad?(self.results)
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
        }
         */
        
    }
}
