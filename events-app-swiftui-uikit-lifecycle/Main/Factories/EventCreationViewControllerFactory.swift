//
//  EventCreationViewControllerFactory.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/15/22.
//

import Foundation
import UIKit
import SwiftUI


class EventCreationViewControllerFactory {
    func controller() -> UIViewController {
        return UIHostingController(rootView: CreateEventView());
    }
}
