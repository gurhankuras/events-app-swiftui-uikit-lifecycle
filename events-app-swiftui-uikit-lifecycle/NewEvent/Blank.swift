//
//  Blank.swift
//  play
//
//  Created by Gürhan Kuraş on 2/19/22.
//

import SwiftUI
import Combine

struct Blank: View {
    @State var notificationService: NotificationService
    @State private var showingWebView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Hello") {
                    //showingWebView = true
                    notificationService.requestPermission()
                    notificationService.send()
                }
                
                Button("Get Presigned Url") {
                    let cancellable = PresignedURLFetcher(network: JsonGetAuthDecorator(decoratee: URLSession.shared, store: SecureTokenStore(keychain: .standard))
                    )
                        .fetch()
                        .sink { completion in
                            
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error)
                            }
                        } receiveValue: { url in
                            print(url)
                        }

                }
                
            }
            .sheet(isPresented: $showingWebView) {
                ControlledWebView()
            }

        }
    }
}

struct Blank_Previews: PreviewProvider {
    static var previews: some View {
        Blank(notificationService: .init(notificationCenter: .current()))
    }
}
