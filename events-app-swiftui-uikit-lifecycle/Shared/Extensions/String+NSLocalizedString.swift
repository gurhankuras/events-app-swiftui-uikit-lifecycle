//
//  String+NSLocalizedString.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/24/22.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: nil, bundle: .main, value: self, comment: self)
    }
}
