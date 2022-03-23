//
//  LazyView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/20/22.
//

import Foundation
import SwiftUI

struct LazyView<T: View>: View {
    let view: () -> T
    
    init(view: @escaping () -> T) {
        self.view = view
        print("LazyView initiliazed!")
    }
    
    var body: some View {
        self.view()
    }
}
