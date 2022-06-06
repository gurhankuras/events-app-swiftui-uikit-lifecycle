//
//  LinkedInView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/29/22.
//

import SwiftUI

class LinkedInVerificationViewModel: ObservableObject {
    
    var didVerified: (() -> ())?
    var didFail: (() -> ())?
    
    let service: LinkedInService
    
    
    init(service: LinkedInService) {
        self.service = service
    }
    
    func verify(code: String) {
        service.verify(with: code) { [weak self] result in
            switch result {
            case .success(_):
                self?.didVerified?()
            case .failure(_):
                self?.didFail?()
            }
        }
    }
    
    
    
    
}

struct LinkedInView: View {
    @StateObject var viewModel: LinkedInVerificationViewModel
    var body: some View {
        LinkedInWebView(
            url: LinkedInURLs.init().code()!,
            completion: { [weak viewModel] code in viewModel?.verify(code: code) }
        )
    }
    
    
}

struct LinkedInView_Previews: PreviewProvider {
    static var previews: some View {
        LinkedInView(viewModel: .init(service: .init(client: HttpAPIClient.shared)))
    }
}
