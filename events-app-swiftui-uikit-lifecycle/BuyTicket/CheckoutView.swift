//
//  CheckoutView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

import SwiftUI
import os

struct CheckoutView: View {
    @ObservedObject var viewModel: CheckoutView.ViewModel
    let htmlContent: String
    let dismiss: () -> ()
    let completion: () -> ()
    
    var body: some View {
        VStack {
            RegularAppBar(title: "Checkout", back: dismiss)
            CheckoutWebView(htmlContent: htmlContent,
                            completion: { concludePayment(res: $0) })
                .overlay(
                    VStack {
                        if viewModel.isLoading {
                            LoadingView(running: $viewModel.isLoading)
                        }
                    }
                )
        }
        .navigationBarHidden(true)
    }
    
    func concludePayment(res: ThreeDSPaymentHandshakeResponse) {
        let req = ThreeDSPaymentCompletionRequest(
            conversationId: res.conversationId,
            conversationData: res.conversationData,
            paymentId: res.paymentId)
        viewModel.pay(request: req, completion: completion)
    }
}

extension CheckoutView {
    class ViewModel: ObservableObject {
        static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                   category: "CheckoutView.ViewModel")
        
        let threeDSPaymentService: ThreeDSPaymentService
        @Published var isLoading = false
        
        init(threeDSPaymentService: ThreeDSPaymentService) {
            self.threeDSPaymentService = threeDSPaymentService
        }
        
        func pay(request: ThreeDSPaymentCompletionRequest, completion: @escaping () -> ()) {
            isLoading = true
            threeDSPaymentService.pay(with: request) { result in
                switch result {
                case .success(let data):
                    Self.logger.debug("Received successfully: \(data)")
                case .failure(let error):
                    Self.logger.debug("An error occured while paying \(error.localizedDescription)")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                }
            }
             
            completion()
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        Text("asdas")
    }
}
